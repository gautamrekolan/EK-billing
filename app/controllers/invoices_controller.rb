class InvoicesController < ApplicationController
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::NumberHelper

  before_filter :login_required, :except => [ :confirm_email, :request_email, :show ]

  # GET /invoices
  def index
    @invoices = Invoice.all(:order => "status_code asc, end_date desc")
    # @invoices = nil

    # pay-attention invoices
    # - invoices to be mailed ("Mail Requested" or ("Opened" and @customer.delivery_method == "Mail"))
    # - invoices to be contacted ("Emailed" and updated >= 14 days ago)
    # - invoices past due ("Emailed", "Mailed", "Confirmed", "Mailed (Secondary)", "Partially Paid", "Reminded" where due_date < now)
    pastdue_status_codes = [1, 2, 3, 4, 5, 6, 7]
    @attention_invoices = Invoice.all(:order => 'end_date desc',
                                      :conditions => [ "(status_code = '4') or (status_code = '1') or (status_code in (?) and due_date < ?)",
                                      pastdue_status_codes, Date.today ])

    # open invoices
    # - "Opened", "Emailed", "Mailed", "Confirmed", "Mailed (Secondary)", "Reminded" where due_date > now
    # @opened_invoices = Invoice.all(:conditions => [ "statuses.status = ?" ])
    # @open_invoices = Invoice.where([ "status in ?" ], [ "Opened", "Emailed", "Mailed", "Confirmed",
    #                                  "Mailed (Secondary)", "Reminded" ]).and.where([ "due_date < " ], Time.now)
    open_status_codes = [1, 2, 3, 4, 5, 6, 7]
    @open_invoices = Invoice.all(:order => 'end_date desc',
                                 :conditions => [ "status_code in (?) and due_date >= ?",
                                                open_status_codes, Date.today ])

    # closed invoices
    # - "Paid"
    closed_status_codes = [8]
    @closed_invoices = Invoice.all(:order => 'end_date desc',
                                 :conditions => [ "status_code in (?)",
                                                closed_status_codes ])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end

  # GET /invoices/1
  def show
    @invoice = Invoice.find(params[:id])

    # check for any warnings (unconfirmed for X days, etc.)
    @status = Status.find_by_invoice_id(@invoice.id, :order => "status_code desc", :limit => 1)
    if @status.status == "Emailed"
      # time_diff_components = Time.diff(Time.now, @status.created_at)
      # if time_diff_components[:day] > 1
      #   @warning = "You emailed this invoice " + time_diff_components[:day].to_s + " ago, and it has not been confirmed."
      # end
    elsif @status.status == "Mail Requested"
      @warning = "This customer has requested a hard copy of this invoice to be mailed."
    elsif @invoice.due_date < Date.today && @invoice.status_code < 8
      @warning = "This invoice is past due."
    end

    @pastdue_items = []
    if @invoice.status_code < 8
      index = 0
      invoices = Invoice.find_all_by_customer_id(@invoice.customer_id)
      invoices.each do |invoice|
        if invoice.status_code < 8 && invoice.id != @invoice.id
          items = Item.find_all_by_invoice_id(invoice.id)
          items.each do |item|
            # only include items that are not denoted as past due on another invoice
            if item.category_id != 14 && invoice.end_date < @invoice.start_date
              @pastdue_items[index] = item.category.name + " - " + item.description + " (" + invoice.name + ")"
              index += 1
            end
          end
        end
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
      format.pdf {
        render :layout => false
      }
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.amount = "0.00"
    @invoice.customer_id = params[:customer]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(params[:invoice])

    respond_to do |format|
      if @invoice.save
        Invoice.update_status(@invoice.id, "Opened")
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully created.') }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to(@invoice, :notice => 'Invoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
    end
  end

  def send_text
    @invoice = Invoice.find(params[:invoice])
    if @invoice.nil? == false
      @customer = Customer.find(@invoice.customer_id)
      if @customer.phone.blank? == false
        @account_sid = 'ACca351063436f41d4b1357d3e2efc7bb8'
        @account_token = '2428ac438afe38001c955ac0d4b713c0'
        @client = Twilio::REST::Client.new(@account_sid, @account_token)
        @client.account.sms.messages.create(
            :from => '(415) 599-2671',
            :to   => '(717) 658-4502', # @customer.phone,
            :body => "Just a reminder from Lower Hopewell that your invoice is due on " + @invoice.due_date.to_s(:long) + ". Thanks! Alida"
        )
      end
    end
  end

  def send_email
    @invoice = Invoice.find(params[:invoice])
    if @invoice.nil? == false
      @customer = Customer.find_by_id(@invoice.customer_id)
      if @customer.nil? == false
        email =  "elysedougherty@gmail.com" #@customer.email
        if email.blank? == false
          # Send email to @email
          pdf = Prawn::Document.new()
          #pdf.text("Oh hai there")
          pdf = build_pdf(pdf, @invoice)
          pdf.render_file("#{Rails.root}/public/files/pdfs/issued/" + @invoice.id.to_s + ".pdf")
          AdminMailer.invoice_issued(@invoice).deliver
          success = Invoice.update_status(@invoice.id, "Emailed")
          if success == true
            redirect_to(@invoice, :notice => "Email was successfully sent.")
          else
            redirect_to(@invoice, :notice => "Something went wrong! Email was NOT successfully sent.")
          end
        else
          redirect_to(@invoice, :notice => "Something went wrong! Email was NOT successfully sent.")
        end
      else
         redirect_to(@invoice, :notice => "Something went wrong! Email was NOT successfully sent.")
      end
    end
  end

  def confirm_email
    # Decrypt encrypted id from params
    @param = params[:invoice]
    #cipher = Gibberish::AES.new("snoopyandlowerhopewellfarm")
    @decrypted = @param # cipher.dec(@param)
    @invoice = Invoice.find_by_id(@decrypted)
    @status = Status.find_by_invoice_id(@invoice.id, :order => "status_code desc", :limit => 1)
    @success = Invoice.update_status(@invoice.id, "Confirmed")
  end

  def request_email
    # Decrypt encrypted id from params
    @param = params[:invoice]
    #cipher = Gibberish::AES.new("snoopyandlowerhopewellfarm")
    @decrypted = @param # cipher.dec(@param)
    @invoice = Invoice.find(@decrypted)
    @status = Status.find_by_invoice_id(@invoice.id, :order => "status_code desc", :limit => 1)
    @success = Invoice.update_status(@invoice.id, "Mail Requested")
  end

  def reminder_email
    @invoice = Invoice.find(params[:invoice])
    AdminMailer.invoice_reminder(@invoice).deliver
    @success = Invoice.update_status(@invoice.id, "Reminded")
    if @success == true
      redirect_to(@invoice, :notice => "Reminder email was sent.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Reminder email was NOT successfully sent.")
    end
  end

  def mark_mailed
    @invoice_id = params[:invoice]
    @method = params[:method]
    @invoice = Invoice.find_by_id(@invoice_id)
    if @method == "primary"
      @success = Invoice.update_status(@invoice.id, "Mailed")
    elsif
       @success = Invoice.update_status(@invoice.id, "Mailed (Secondary)")
    end
    if @success == true
      @customer = Customer.find_by_id(@invoice.customer_id)
      if @customer.nil? == false
        @email = @customer.email
        if @email.blank? == false
          #AdminMailer.invoice_mailed(@invoice).deliver
        end
      end
      redirect_to(@invoice, :notice => "Invoice is now marked as mailed.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Invoice status was NOT successfully updated.")
    end
  end

  def mark_paid
    @invoice_id = params[:invoice]
    @invoice = Invoice.find_by_id(@invoice_id)
    @success = Invoice.update_status(@invoice.id, "Paid")
    if @success == true
      @customer = Customer.find_by_id(@invoice.customer_id)
      if @customer.nil? == false
        @email = @customer.email
        if @email.blank? == false
          #AdminMailer.invoice_paid(@invoice).deliver
        end
      end
      redirect_to(@invoice, :notice => "Invoice is now marked as paid.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Invoice status was NOT successfully updated.")
    end
  end

  def add_single_auto_item()
    @invoice = Invoice.find(params[:invoice])
    @auto = Auto.find(params[:auto])
    @item = Item.new
    @item.category_id = @auto.category_id
    @item.description = @auto.description
    @item.quantity = @auto.quantity
    @item.amount = @auto.amount
    @item.horse_id = @auto.horse_id
    @item.customer_id = @auto.customer_id
    @item.invoice_id = @invoice.id
    if @item.save
      # update invoice amount
      new_amount = @invoice.amount + @item.amount
      @invoice.update_attribute("amount", new_amount)
      redirect_to(@invoice, :notice => "Auto item was added successfully.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Auto item was NOT added successfully.")
    end
  end

  def add_all_auto_items()
    @invoice = Invoice.find(params[:invoice])
    items_added = 0
    @invoice.customer.autos.each do |auto|
      if auto.end_date.blank? == false
        if auto.end_date > Date.today
          @item = Item.new
          @item.category_id = auto.category_id
          @item.description = auto.description
          @item.quantity = auto.quantity
          @item.amount = auto.amount
          @item.horse_id = auto.horse_id
          @item.customer_id = auto.customer_id
          @item.invoice_id = @invoice.id
          if @item.save
            # update invoice amount
            @new_amount = @invoice.amount + @item.amount
            @invoice.update_attribute("amount", @new_amount)
            items_added += 1
          end
        end
      end
    end
    if items_added > 0
      redirect_to(@invoice, :notice => items_added.to_s + " auto items were added successfully.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Auto items were NOT successfully updated.")
    end
  end

  def build_pdf(pdf, invoice)
    @invoice = invoice
    logopath = "#{Rails.root}/public/images/lhflogo.jpg"
    pdf.image logopath, :width => 134, :height => 90, :position => :center

    pdf.move_down 30

    pdf.font_size = 10
    pdf.text "Please make checks payable to:", :style => :bold
    pdf.text "Alida Burkholder or Lower Hopewell Farm"
    pdf.text "395 Speedwell Forge Road"
    pdf.text "Lititz, PA 17543"
    pdf.text "(717) 587-7421"
    pdf.text "lhfapps@ptd.net"

    pdf.move_down 20
    pdf.text @invoice.name, :size => 12, :style => :bold
    pdf.font_size = 10
    pdf.text "Start Date: " + @invoice.start_date.to_s(:long)
    pdf.text "End Date: " + @invoice.end_date.to_s(:long)
    pdf.text "Due Date: " + @invoice.due_date.to_s(:long)

    if @invoice.notes.blank? == false
      pdf.move_down 20
      pdf.text "**NOTE: " + @invoice.notes
    end

    pdf.move_down 20
    pdf.text "Invoice Items", :size => 12, :style => :bold
    pdf.font_size = 10

    if @invoice.items.empty? == false
      items = @invoice.items.map do |item|
       [
            item.category.name,
            item.description,
            item.quantity,
            number_to_currency(item.amount)
       ]
      end

      pdf.table items, :headers => [ 'Category', 'Description', 'Quantity', 'Total' ],
        :border_style => :grid, :font_size => 10, :column_widths => { 0 => 150, 1 => 225, 2 => 65, 3 => 100 },
        :align_headers => { 0 => :left, 1 => :left, 2 => :center, 3 => :center },
        :align => { 0 => :left, 1 => :left, 2 => :right, 3 => :right }
    else
      pdf.text "There are no items on this invoice."
    end

    pdf.move_down 20
    pdf.text "AMOUNT DUE: " + number_to_currency(@invoice.amount), :size => 14, :align => :right, :style => :bold

    pdf.move_down 20
    pdf.text "Please contact Alida if any of your information has changed:", :style => :bold
    pdf.text @invoice.customer.first_name + " " + @invoice.customer.last_name
    pdf.text @invoice.customer.address
    pdf.text @invoice.customer.city + ", " + @invoice.customer.state + " " + @invoice.customer.zip
    pdf.text number_to_phone(@invoice.customer.phone)
    pdf.text @invoice.customer.email

    pdf.move_down 30
    pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
    pdf.text "- Alida", :size => 12, :align => :right
    return pdf
  end

end
