class CustomsController < ApplicationController

  before_filter :login_required

  # GET /customs/sample/1
  def sample
    @horse = Horse.find(params[:id])
  end

  # GET /customs/new
  def new
    @custom = Custom.new
    @custom.organization_id = session[:user][:organization_id]
  end

  # GET /customs/1/edit
  def edit
    @custom = Custom.find(params[:id])
  end

  # POST /customs
  def create
    @custom = Custom.new(params[:custom])

    if @custom.save
      redirect_to(edit_custom_path(@custom), :notice => 'Customization was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /customs/1
  def update
    @custom = Custom.find(params[:id])

    if @custom.update_attributes(params[:custom])
      redirect_to(edit_custom_path(@custom), :notice => 'Customization was successfully updated.')
    else
      render :action => "edit"
    end
  end

end
