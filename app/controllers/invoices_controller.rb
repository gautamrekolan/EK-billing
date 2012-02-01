include ActionView::Helpers::NumberHelper

class InvoicesController < ApplicationController

  before_filter :login_required #, :except => [ :confirm, :request_mail ]
  before_filter :manager_required, :except => [ :index, :show, :confirm, :request_mail ]

  # GET /invoices
  def index
    if session[:user][:access] == "customer"
      @invoices = Invoice.find_all_by_customer_id(session[:user][:customer_id])
    else
      # pay-attention invoices
      # - invoices to be mailed ("Mail Requested" or ("Opened" and @customer.delivery_method == "Mail"))
      # - invoices past due ("Emailed", "Mailed", "Confirmed", "Mailed (Secondary)", "Partially Paid", "Reminded" where due_date < now)
      pastdue_status_codes = [1, 2, 3, 4, 5, 6, 7]
      @attention_invoices = Invoice.all(:order => 'end_date desc',
                                        :conditions => [ "(status_code = '4') or (status_code in (?) and due_date < ?)",
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
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.organization_id = session[:user][:organization_id]
    @invoice.customer_id = params[:customer]

    if @invoice.customer_id.blank?
      @customers = Customer.find_all_by_organization_id(@invoice.organization_id)
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(params[:invoice])
    # default invoice amount = 0
    @invoice.amount = 0
    #@invoice.status_code = 1
    #@invoice.status = "Opened"

    if @invoice.save
      Invoice.update_status(@invoice.id, "Opened")
      redirect_to(@invoice, :notice => 'Invoice was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /invoices/1
  def update
    @invoice = Invoice.find(params[:id])

    if @invoice.update_attributes(params[:invoice])
      redirect_to(@invoice, :notice => 'Invoice was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice = Invoice.find(params[:id])
    if @invoice.destroy
      redirect_to(invoices_url, :notice => 'Invoice was successfully deleted.')
    end
  end

  def text
    @invoice = Invoice.find(params[:id])
    if @invoice.nil? == false
      @customer = Customer.find(@invoice.customer_id)
      if @customer.cell.blank? == false
        @account_sid = 'ACca351063436f41d4b1357d3e2efc7bb8'
        @account_token = '2428ac438afe38001c955ac0d4b713c0'
        @client = Twilio::REST::Client.new(@account_sid, @account_token)
        @client.account.sms.messages.create(
            :from => '(415) 599-2671',
            :to   => '(717) 658-4502', # @customer.cell,
            :body => "Just a reminder from " + @invoice.organization.name + " that your invoice is due on " + @invoice.due_date.strftime("%B %e, %Y") + ". Thank you!"
        )
        success = Invoice.update_status(@invoice.id, "Reminded")
        if success == true
          redirect_to(@invoice, :notice => "Text message reminder was successfully sent.")
        else
          redirect_to(@invoice, :notice => "Something went wrong! Text message reminder was NOT successfully sent.")
        end
      else
        redirect_to(@invoice, :notice => "Something went wrong! Text message reminder was NOT successfully sent.")
      end
    end
  end

  def issued
    @invoice = Invoice.find(params[:id])
    if @invoice.nil? == false
      @customer = Customer.find_by_id(@invoice.customer_id)
      if @customer.nil? == false
        email =  "elysedougherty@gmail.com" #@customer.email
        if email.blank? == false
          # Send email to @email
          pdf = Prawn::Document.new()
          pdf = build_pdf(pdf, @invoice)
          pdf.render_file("#{Rails.root}/public/files/pdfs/issued/" + @invoice.id.to_s + ".pdf")
          InvoiceMailer.invoice_issued(@invoice).deliver
          success = Invoice.update_status(@invoice.id, "Emailed")
          if success == true
            redirect_to(@invoice, :notice => "Invoice email was successfully sent.")
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

  def confirm
    # Decrypt encrypted id from params
    #@param = params[:id]
    #cipher = Gibberish::AES.new("snoopyandlowerhopewellfarm")
    #@decrypted = cipher.dec(@param) # @param
    #@invoice = Invoice.find_by_id(@decrypted)
    @invoice = Invoice.find(params[:id])
    #@status = Status.find_by_invoice_id(@invoice.id, :order => "status_code desc", :limit => 1)
    success = Invoice.update_status(@invoice.id, "Confirmed")
    if success == true
      redirect_to(@invoice, :notice => "Invoice was confirmed successfully. Thank you in advance for your prompt payment!")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Invoice was NOT successfully confirmed.")
    end
  end

  def request_mail
    # Decrypt encrypted id from params
    #@param = params[:id]
    #cipher = Gibberish::AES.new("snoopyandlowerhopewellfarm")
    #@decrypted = cipher.dec(@param) # @param
    #@invoice = Invoice.find(@decrypted)

    @invoice = Invoice.find(params[:id])
    success = Invoice.update_status(@invoice.id, "Mail Requested")
    if success == true
      redirect_to(@invoice, :notice => "Your request was submitted successfully. A copy of this invoice will be on its way to you soon!")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Your request was NOT submitted successfully.")
    end
  end

  def reminder
    @invoice = Invoice.find(params[:id])
    InvoiceMailer.invoice_reminder(@invoice).deliver
    success = Invoice.update_status(@invoice.id, "Reminded")
    if success == true
      redirect_to(@invoice, :notice => "Reminder email was successfully sent.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Reminder email was NOT successfully sent.")
    end
  end

  def mailed
    @invoice_id = params[:id]
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
          #InvoiceMailer.invoice_mailed(@invoice).deliver
        end
      end
      redirect_to(@invoice, :notice => "Invoice status was successfully updated.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Invoice status was NOT successfully updated.")
    end
  end

  def paid
    @invoice_id = params[:id]
    @invoice = Invoice.find_by_id(@invoice_id)
    @success = Invoice.update_status(@invoice.id, "Paid")
    if @success == true
      @customer = Customer.find_by_id(@invoice.customer_id)
      if @customer.nil? == false
        @email = @customer.email
        if @email.blank? == false
          #InvoiceMailer.invoice_paid(@invoice).deliver
        end
      end
      redirect_to(@invoice, :notice => "Invoice status was successfully updated.")
    else
      redirect_to(@invoice, :notice => "Something went wrong! Invoice status was NOT successfully updated.")
    end
  end

  def build_pdf(pdf, invoice)
    # TODO:
    # Allow uploading of organization logo
    # Allow submission of 'Checks payable to'
    # Allow toggle of customer information validation/check
    # Allow submission of sign-off line - default = 'Thank you for your prompt payment and continued business!'

    @invoice = invoice

    #logopath = "#{Rails.root}/public/images/logo.jpg"
    #pdf.image logopath, :width => 134, :height => 90, :position => :center

    pdf.move_down 30

    pdf.font_size = 10
    pdf.text "Please make checks payable to:", :style => :bold
    if @invoice.organization.custom.nil? == false
      if @invoice.organization.custom.checks_payable_to.blank? == false
        pdf.text @invoice.organization.custom.checks_payable_to
      else
        pdf.text @invoice.organization.name + " or " + @invoice.organization.contact
      end
    else
      pdf.text @invoice.organization.name + " or " + @invoice.organization.contact
    end
    pdf.text @invoice.organization.address
    pdf.text @invoice.organization.city + ", " + @invoice.organization.state + " " + @invoice.organization.zip
    pdf.text number_to_phone(@invoice.organization.phone)
    pdf.text @invoice.organization.email

    pdf.move_down 20
    pdf.text @invoice.name, :size => 12, :style => :bold
    pdf.font_size = 10
    pdf.text "Start Date: " + @invoice.start_date.strftime("%B %e, %Y")
    pdf.text "End Date: " + @invoice.end_date.strftime("%B %e, %Y")
    pdf.text "Due Date: " + @invoice.due_date.strftime("%B %e, %Y")

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

    if @invoice.organization.custom.nil? == false
      if @invoice.organization.custom.customer_info_check == 1
        pdf.move_down 20
        pdf.text "Please contact " + @invoice.organization.contact + " if any of your information has changed:", :style => :bold
        pdf.text @invoice.customer.first_name + " " + @invoice.customer.last_name
        pdf.text @invoice.customer.address
        pdf.text @invoice.customer.city + ", " + @invoice.customer.state + " " + @invoice.customer.zip
        if @invoice.customer.cell.blank? == false
          pdf.text "Cell: " + number_to_phone(@invoice.customer.cell, :area_code => true)
        end
        if @invoice.customer.home.blank? == false
          pdf.text "Home: " + number_to_phone(@invoice.customer.home, :area_code => true)
        end
        if @invoice.customer.work.blank? == false
          pdf.text "Work: " + number_to_phone(@invoice.customer.work, :area_code => true)
        end
        pdf.text @invoice.customer.email
      end
    else
      pdf.move_down 20
        pdf.text "Please contact " + @invoice.organization.contact + " if any of your information has changed:", :style => :bold
        pdf.text @invoice.customer.first_name + " " + @invoice.customer.last_name
        pdf.text @invoice.customer.address
        pdf.text @invoice.customer.city + ", " + @invoice.customer.state + " " + @invoice.customer.zip
        if @invoice.customer.cell.blank? == false
          pdf.text "Cell: " + number_to_phone(@invoice.customer.cell, :area_code => true)
        end
        if @invoice.customer.home.blank? == false
          pdf.text "Home: " + number_to_phone(@invoice.customer.home, :area_code => true)
        end
        if @invoice.customer.work.blank? == false
          pdf.text "Work: " + number_to_phone(@invoice.customer.work, :area_code => true)
        end
        pdf.text @invoice.customer.email
    end

    pdf.move_down 30
    if @invoice.organization.custom.nil? == false
      if @invoice.organization.custom.signoff_line.blank? == false
        pdf.text @invoice.organization.custom.signoff_line, :size => 12, :style => :bold, :align => :right
      else
        pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
      end
    else
      pdf.text "Thank you for your prompt payment and continued business!", :size => 12, :style => :bold, :align => :right
    end
    return pdf
  end

end
