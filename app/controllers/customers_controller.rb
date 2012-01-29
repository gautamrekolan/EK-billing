class CustomersController < ApplicationController

  before_filter :login_required, :except => [ :change_delivery ]

  # GET /customers
  # GET /customers.xml
  def index
    @customers = Customer.all(:order => "active desc, last_name asc, first_name asc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.xml
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.xml
  def new
    @customer = Customer.new
    @states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID",
               "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
               "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
               "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    @methods = ["Email", "Mail"]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])

    @states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID",
               "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
               "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
               "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    @methods = ["Email", "Mail"]

  end

  # POST /customers
  # POST /customers.xml
  def create
    @customer = Customer.new(params[:customer])
    # Remove all non-digit characters from the phone number
    # (Source: http://stackoverflow.com/questions/3368016/rails-on-ruby-validating-and-changing-a-phone-number)
    @customer.phone = @customer.phone.gsub(/\D/, '')

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(@customer, :notice => 'Customer was successfully created.') }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @customer = Customer.find(params[:id])
    # Remove all non-digit characters from the phone number
    # (Source: http://stackoverflow.com/questions/3368016/rails-on-ruby-validating-and-changing-a-phone-number)
    params[:customer][:phone] = params[:customer][:phone].gsub(/\D/, '')

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to(@customer, :notice => 'Customer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.xml
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to(customers_url) }
      format.xml  { head :ok }
    end
  end

  def change_delivery
    @customer = Customer.find(params[:customer])
    if @customer.nil? == false
      @customer.update_attribute("delivery_method", "Mail")
    end
  end

  def create_invoices
    @customers = Customer.all(:order => "last_name asc, first_name asc")
    @invoice = Invoice.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @customers }
    end
  end

  def build_invoices
    params[:customer_id].each do |customer|
      customer_id = Integer(customer)
      if customer_id > 0
        @customer = Customer.find(customer_id)
        if @customer.nil? == false
          @invoice = Invoice.new(params[:invoice])
          @invoice.customer_id = customer_id
          @invoice.created_at = Time.now
          @invoice.updated_at = Time.now
          @invoice.status_code = 1
          @invoice.status = "Opened"
          if @invoice.save
            Invoice.update_status(@invoice.id, "Opened")
          end
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to(invoices_path, :notice => 'Invoices were successfully created.') }
      format.xml  { head :ok }
    end
  end

end
