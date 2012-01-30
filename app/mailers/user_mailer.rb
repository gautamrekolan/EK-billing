class UserMailer < ActionMailer::Base
  default :from => "info@easykeeperbilling.com"
  default :host => "localhost:3000"

  def welcome(email)
    mail(:to => "elysedougherty@gmail.com", :subject => "Welcome to Easy Keeper Billing!")
    # mail(:to => email, :subject => "Welcome to Easy Keeper Billing!")
  end

end
