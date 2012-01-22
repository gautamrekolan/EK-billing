class Auto < ActiveRecord::Base

  belongs_to :customer
  belongs_to :horse

  validates :description, :presence => true, :length => { :maximum => 250 }
  validates :quantity,    :presence => true, :numericality => true
  validates :amount,      :presence => true, :format => { :with => /^[0-9]*(\.[0-9]{1,2})?$|^[0-9]{1,3}(,[0-9]{3})*(\.[0-9]{1,2})?$/ }
  validates :customer_id, :presence => true, :numericality => true
  validates :horse_id,    :numericality => true, :if => :horse?

  def horse?()
    if self.horse_id.blank? == false
      true
    else
      false
    end
  end

end
