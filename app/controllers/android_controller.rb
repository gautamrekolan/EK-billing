class AndroidController < ApplicationController

  def get_all_customers
    @customers = Customer.find_all_by_organization_id(params[:organization_id])

    render :json => @customers
  end

end
