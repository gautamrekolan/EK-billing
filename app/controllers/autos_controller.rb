class AutosController < ApplicationController

  before_filter :login_required

  # GET /autos/new
  # GET /autos/new.xml
  def new
    @auto = Auto.new
    @auto.customer_id = params[:customer]
    @horses = Horse.find_all_by_customer_id(@auto.customer_id)
    @days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @auto }
    end
  end

  # GET /customers/1/edit
  def edit
    @auto = Auto.find(params[:id])
    @horses = Horse.find_all_by_customer_id(@auto.customer_id)
    @days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31]
  end

  # POST /customers
  def create
    @auto = Auto.new(params[:auto])
    @customer = Customer.find(@auto.customer_id)

    if @auto.save
      redirect_to(@customer, :notice => 'Auto item was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /customers/1
  def update
    @auto = Auto.find(params[:id])
    @customer = Customer.find(@auto.customer_id)

    if @auto.update_attributes(params[:auto])
      redirect_to(@customer, :notice => 'Auto item was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /invoices/1
  def destroy
    @auto = Auto.find(params[:id])
    @customer = Customer.find(@auto.customer_id)
    if @auto.destroy
      redirect_to(@customer, :notice => 'Auto item was successfully canceled.')
    end
  end

end
