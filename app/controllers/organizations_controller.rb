class OrganizationsController < ApplicationController

  before_filter :login_required
  before_filter :admin_required, :except => [ :new, :create, :edit, :update ]
  before_filter :manager_required

  # GET /organizations
  def index
    @organizations = Organization.all(:order => "name asc")
  end

  # GET /organizations/1
  def show
    @organization = Organization.find(params[:id])
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  def create
    @organization = Organization.new(params[:organization])

    if @organization.save
      @user = User.find(session[:user])
      @user.update_attribute("organization_id", @organization.id)
      session[:user] = @user
      if session[:user][:access] == "admin"
        redirect_to(@organization, :notice => 'Organization was successfully created.')
      else
        redirect_to(edit_organization_path(@organization), :notice => 'Thanks! Your barn details were successfully updated.')
      end
    else
      render :action => "new"
    end
  end

  # PUT /organizations/1
  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes(params[:organization])
      if session[:user][:access] == "admin"
        redirect_to(@organization, :notice => 'Organization was successfully updated.')
      else
        redirect_to(edit_organization_path(@organization), :notice => 'Your barn details were successfully updated.')
      end
    else
      render :action => "edit"
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization = Organization.find(params[:id])
    if @organization.destroy
      redirect_to(organizations_url, :notice => 'Organization was successfully deleted.')
    end
  end

end
