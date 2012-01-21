class UsersController < ApplicationController

 before_filter :login_required, :except => [ :new, :create, :login ]

  def login
     if request.post?
       if session[:user] = User.authenticate(params[:user][:username], params[:user][:password])
         flash[:message] = "Login successful"
         redirect_to_stored
       else
         flash[:warning] = "Login unsuccessful"
       end
     end
  end

  def logout
    session[:user] = nil
    session[:return_to] = nil
    flash[:message] = "Logged out"
    redirect_to :action => 'login'
  end

  # GET /users
  # GET /users.xml
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @user.organization_id = params[:organization]
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @user.update_password = true

    respond_to do |format|
      if @user.save
        session[:user] = @user
        if session[:user][:access] == "admin"
          format.html { redirect_to(@user, :notice => 'User was successfully created.') }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          format.html { redirect_to(root_path) }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @user.update_password = false

    respond_to do |format|
      if @user.update_attributes(:name => params[:user][:name], :email => params[:user][:email], :username => params[:user][:username])
        format.html { redirect_to(edit_user_path(@user), :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
