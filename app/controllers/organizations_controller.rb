class OrganizationsController < ApplicationController

  before_filter :login_required
  before_filter :admin_required, :except => [ :new, :create, :edit, :update ]

  # GET /organizations
  # GET /organizations.xml
  def index
    @organizations = Organization.all(:order => "name asc")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.xml
  def show
    @organization = Organization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.xml
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.xml
  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        @user = User.find(session[:user])
        @user.update_attribute("organization_id", @organization.id)
        session[:user] = @user
        if @user.access == "admin"
          format.html { redirect_to(@organization, :notice => 'Organization was successfully created.') }
          format.xml  { render :xml => @organization, :status => :created, :location => @organization }
        else
          format.html { redirect_to(edit_organization_path(@organization), :notice => 'Thanks! Your barn details were successfully updated.') }
          format.xml  { render :xml => @organization, :status => :created, :location => @organization }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        if session[:user][:access] == "admin"
          format.html { redirect_to(@organization, :notice => 'Organization was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(edit_organization_path(@organization), :notice => 'Your barn details were successfully updated.') }
          format.xml  { head :ok }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.xml
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to(organizations_url) }
      format.xml  { head :ok }
    end
  end
end
