class Item < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :customer
  belongs_to :horse
  belongs_to :category

  validates :category_id, :presence => true, :numericality => true
  validates :description, :presence => true, :length => { :maximum => 250 }
  validates :quantity,    :presence => true, :numericality => true
  # TO-DO: Validate currency
  validates :amount,      :presence => true, :numericality => true
  validates :customer_id, :presence => true
  validates :invoice_id,  :presence => true
end
