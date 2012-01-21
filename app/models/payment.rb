class Payment < ActiveRecord::Base

  belongs_to :invoice

  validates :payment_type,  :presence => true
  validates :amount,        :presence => true, :format => { :with => /^[0-9]*(\.[0-9]{1,2})?$|^[0-9]{1,3}(,[0-9]{3})*(\.[0-9]{1,2})?$/ }
  validates :invoice_id,    :presence => true, :numericality => true

end
