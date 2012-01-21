class Item < ActiveRecord::Base

  belongs_to :category
  belongs_to :invoice
  belongs_to :customer
  belongs_to :horse
  belongs_to :organization

  validates :category_id,     :presence => true, :numericality => true
  validates :description,     :presence => true, :length => { :maximum => 250 }
  validates :quantity,        :presence => true, :numericality => true
  validates :amount,          :presence => true, :format => { :with => /^[0-9]*(\.[0-9]{1,2})?$|^[0-9]{1,3}(,[0-9]{3})*(\.[0-9]{1,2})?$/ }
  validates :organization_id, :presence => true, :numericality => true
  validates :customer_id,     :presence => true, :numericality => true
  validates :horse_id,        :presence => true, :numericality => true
  validates :invoice_id,      :presence => true, :numericality => true

end
