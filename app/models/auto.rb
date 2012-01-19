class Auto < ActiveRecord::Base
  belongs_to :customer
  belongs_to :horse
  belongs_to :category

  validates :category_id,     :presence => true
  validates :quantity,        :presence => true, :numericality => true
  validates :amount,          :presence => true
  validates :customer_id,     :presence => true, :numericality => true
end
