class AdminController < ApplicationController

  before_filter :login_required

  def admin
    if session[:user].nil?
      redirect_to login_path
    end
    # drag and drop invoice building
    @categories = Category.all(:order => "category asc, name asc")
    @customers = Customer.all(:order => "last_name asc, first_name asc")
  end

  def email_customers
    @customers = Customer.all()
    #@customer = Customer.find(21)
    #if @customer.email.blank? == false
    #  InvoiceMailer.welcome(@customer).deliver
    #end
    @customers.each do |customer|
      if customer.email.blank? == false
        InvoiceMailer.welcome(customer).deliver
      end
    end

  end

end