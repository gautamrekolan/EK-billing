class ApplicationController < ActionController::Base
  protect_from_forgery

  #before_filter :prepare_for_mobile

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
      redirect_to :controller => 'pages', :action => 'access_denied'
    end
  end

  def manager_required
    if session[:user]
      if session[:user][:access] == "manager" || session[:user][:access] == "admin"
        return true
      end
      flash[:warning] = "Oops! You do not have permission to access this area."
      session[:return_to] = request.request_uri
      redirect_to :controller => 'pages', :action => 'access_denied'
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

  private

    def mobile_device?
      if session[:mobile_param]
        session[:mobile_param] == "1"
      else
        request.user_agent =~ /Mobile|webOS/
      end
    end
    helper_method :mobile_device?

    def prepare_for_mobile
      session[:mobile_param] = params[:mobile] if params[:mobile]
      request.format = :mobile if mobile_device?
    end

    layout :which_layout
    def which_layout
      mobile_device? ? 'mobile' : 'application'
    end
end
