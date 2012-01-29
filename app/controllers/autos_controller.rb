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
  # POST /customers.xml
  def create
    @auto = Auto.new(params[:auto])
    @customer = Customer.find(@auto.customer_id)

    respond_to do |format|
      if @auto.save
        format.html { redirect_to(@customer, :notice => 'Auto item was successfully created.') }
        format.xml  { render :xml => @auto }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @auto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.xml
  def update
    @auto = Auto.find(params[:id])
    @customer = Customer.find(@auto.customer_id)

    respond_to do |format|
      if @auto.update_attributes(params[:auto])
        format.html { redirect_to(@customer, :notice => 'Auto item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  def destroy
    @auto = Auto.find(params[:id])
    @customer = Customer.find(@auto.customer_id)
    @auto.destroy

    respond_to do |format|
      format.html { redirect_to(@customer, :notice => 'Auto item was successfully canceled.') }
      format.xml  { head :ok }
    end
  end

end
