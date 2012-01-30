class CustomersController < ApplicationController

  before_filter :login_required, :except => [ :change_delivery ]

  # GET /customers
  def index
    @customers = Customer.all(:order => "active desc, last_name asc, first_name asc")
  end

  # GET /customers/1
  def show
    @customer = Customer.find(params[:id])
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @customer.organization_id = session[:user][:organization_id]
    @states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID",
               "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
               "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
               "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    @methods = ["Email", "Mail"]
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
  def create
    @customer = Customer.new(params[:customer])
    # Remove all non-digit characters from the phone number
    # (Source: http://stackoverflow.com/questions/3368016/rails-on-ruby-validating-and-changing-a-phone-number)
    @customer.cell = @customer.cell.gsub(/\D/, '')
    @customer.home = @customer.home.gsub(/\D/, '')
    @customer.work = @customer.work.gsub(/\D/, '')

    if @customer.save
      redirect_to(@customer, :notice => 'Customer was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /customers/1
  def update
    @customer = Customer.find(params[:id])
    # Remove all non-digit characters from the phone number
    # (Source: http://stackoverflow.com/questions/3368016/rails-on-ruby-validating-and-changing-a-phone-number)
    params[:customer][:cell] = params[:customer][:cell].gsub(/\D/, '')
    params[:customer][:home] = params[:customer][:home].gsub(/\D/, '')
    params[:customer][:work] = params[:customer][:work].gsub(/\D/, '')

    if @customer.update_attributes(params[:customer])
      redirect_to(@customer, :notice => 'Customer was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /customers/1
  def destroy
    @customer = Customer.find(params[:id])
    if @customer.destroy
      redirect_to(customers_path, :notice => 'Customer was successfully removed.')
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