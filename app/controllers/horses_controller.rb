class HorsesController < ApplicationController

  before_filter :login_required
  before_filter :manager_required, :except => [ :index, :show, :edit, :update ]

  # GET /horses
  def index
    if session[:user][:access] == "customer"
      @horses = Horse.find_all_by_customer_id(session[:user][:customer_id])
    else
      @horses = Horse.find_all_by_organization_id(session[:user][:organization_id])
    end
  end

  # GET /horses/1
  def show
    @horse = Horse.find(params[:id])
  end

  # GET /horses/new
  def new
    @horse = Horse.new
    @horse.organization_id = session[:user][:organization_id]
    @horse.customer_id = params[:customer]
  end

  # GET /horses/1/edit
  def edit
    @horse = Horse.find(params[:id])
  end

  # POST /horses
  def create
    @horse = Horse.new(params[:horse])

    if @horse.save
      redirect_to(edit_horse_path(@horse), :notice => 'Horse was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /horses/1
  def update
    @horse = Horse.find(params[:id])

    if @horse.update_attributes(params[:horse])
      redirect_to(edit_horse_path(@horse), :notice => 'Horse was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /horses/1
  def destroy
    @horse = Horse.find(params[:id])
    @customer = @horse.customer
    if @horse.destroy
      redirect_to(@customer, :notice => 'Horse was successfully deleted.')
    end
  end

end
