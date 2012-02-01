class ApplicationController < ActionController::Base
  protect_from_forgery

  def login_required
    if session[:user]
      return true
    end
    flash[:warning] = "Please login to continue."
    session[:return_to] = request.request_uri
    redirect_to :controller => 'users', :action => 'login'
  end
  
  def admin_required
    if session[:user]
      if session[:user][:access] == "admin"
        return true
      end
      flash[:warning] = "Oops! You do not have permission to access this area."
      session[:return_to] = request.request_uri
      redirect_to :controller => 'pages', :action => 'home'
    end
  end

  def manager_required
    if session[:user]
      if session[:user][:access] == "manager"
        return true
      end
      flash[:warning] = "Oops! You do not have permission to access this area."
      session[:return_to] = request.request_uri
      redirect_to :controller => 'pages', :action => 'home'
    end
  end

  def current_user
    session[:user]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to return_to
    else
      redirect_to :controller => 'pages', :action => 'home'
    end
  end
end
