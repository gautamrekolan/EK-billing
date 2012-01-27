class AutosController < ApplicationController

  before_filter :login_required

  # GET /autos/new
  def new
    @auto = Auto.new
    @auto.customer_id = params[:customer]
    @categories = Category.find_all_by_organization_id(session[:user][:organization_id], :order => "category asc, name asc")
  end

  # GET /autos/1/edit
  def edit
    @auto = Auto.find(params[:id])
  end

  # POST /autos
  def create
    @auto = Auto.new(params[:auto])

    if @auto.save
      redirect_to(@auto.customer, :notice => 'Auto item was successfully created.')
    end
  end

  # PUT /autos/1
  def update
    @auto = Auto.find(params[:id])

    if @auto.update_attributes(params[:auto])
      redirect_to(@auto.customer, :notice => 'Auto item was successfully updated.')
    end
  end

  # DELETE /autos/1
  def destroy
    @auto = Auto.find(params[:id])
    @customer = @auto.customer
    if @auto.destroy
      redirect_to(@customer, :notice => 'Auto item was successfully deleted.')
    end
  end

end
