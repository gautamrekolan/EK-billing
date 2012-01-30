class PagesController < ApplicationController

  layout 'application', :except => [ :home, :signup ]

  def home
    @potential = Potential.new
  end

  def signup
    @potential = Potential.new(params[:potential])
    if @potential.save

      redirect_to(root_path, :notice => 'Email successfully submitted. Thanks!')
    else
      render 'home'
    end
  end

  def about

  end

  def contact

  end

  def builder
    @categories = Category.find_all_by_organization_id(session[:user][:organization_id], :order => "category asc, name asc")
    @customers = Customer.find_all_by_organization_id(session[:user][:organization_id], :order => "last_name asc, first_name asc")
  end

end
