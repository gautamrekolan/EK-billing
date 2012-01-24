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
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
    @user.organization_id = params[:organization]
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(params[:user])
    @user.update_password = true

   if @user.save
      session[:user] = @user
      if session[:user][:access] == "admin"
        redirect_to(@user, :notice => 'User was successfully created.')
      else
        redirect_to(root_path)
      end
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])
    @user.update_password = false

    if @user.update_attributes(:name => params[:user][:name], :email => params[:user][:email], :username => params[:user][:username])
      redirect_to(edit_user_path(@user), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to(users_url, :notice => 'User was successfully deleted.')
    end
  end

end
