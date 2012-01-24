class CustomersController < ApplicationController

  before_filter :login_required

  # GET /customers
  def index
    if session[:user].nil? == false
      if session[:user][:organization_id].blank? == false
        @customers = Customer.find_all_by_organization_id(session[:user][:organization_id], :order => "last_name asc, first_name asc")
      end
    end
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

    respond_to do |format|
      if @customer.save
        redirect_to(edit_customer_path(@customer), :notice => 'Customer was successfully created.')
      else
        @states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID",
               "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
               "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
               "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
        @methods = ["Email", "Mail"]
        render :action => "new"
      end
    end
  end

  # PUT /customers/1
  def update
    @customer = Customer.find(params[:id])

    if @customer.update_attributes(params[:customer])
        redirect_to(edit_customer_path(@customer), :notice => 'Customer was successfully updated.')
    else
      @states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID",
             "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO",
             "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
             "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
      @methods = ["Email", "Mail"]
      render :action => "edit"
    end
  end

  # DELETE /customers/1
  def destroy
    @customer = Customer.find(params[:id])
    if @customer.destroy
      redirect_to(customers_url, :notice => 'Customer was successfully deleted.')
    end
  end

end
