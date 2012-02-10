class AndroidController < ApplicationController

  def get_all_customers
    @customers = Customer.find_all_by_organization_id(params[:organization_id])

    @encoded = ActiveSupport::JSON.encode(@customers)
  end

end
