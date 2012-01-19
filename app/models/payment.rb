class Payment < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :customer

  validates :payment_method,    :presence => true
  validates :payment_amount,    :presence => true
end
