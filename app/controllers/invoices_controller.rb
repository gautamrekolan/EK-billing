class InvoicesController < ApplicationController

  before_filter :login_required

  # GET /invoices
  # GET /invoices.xml
  def index
    @invoices = Invoice.find_all_by_organization_id(session[:user][:organization_id])

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
  # GET /invoices/1.xml
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
    end
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    @invoice = Invoice.new
    @invoice.organization_id = session[:user][:organization_id]
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
  # POST /invoices.xml
  def create
    @invoice = Invoice.new(params[:invoice])
    # default invoice amount = 0
    @invoice.amount = 0
    #@invoice.status_code = 1
    #@invoice.status = "Opened"

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
  # PUT /invoices/1.xml
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to(edit_invoice_path(@invoice), :notice => 'Invoice was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(invoices_url) }
      format.xml  { head :ok }
    end
  end
end
