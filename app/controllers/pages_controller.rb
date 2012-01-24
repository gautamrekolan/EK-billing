class PagesController < ApplicationController

  def home

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
