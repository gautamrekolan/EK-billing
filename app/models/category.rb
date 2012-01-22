class Category < ActiveRecord::Base

  belongs_to :organization

  validates :category,        :presence => true, :length => { :maximum => 250 }
  validates :name,            :presence => true, :length => { :maximum => 250 }
  validates :amount,          :format => { :with => /^[0-9]*(\.[0-9]{1,2})?$|^[0-9]{1,3}(,[0-9]{3})*(\.[0-9]{1,2})?$/ }, :if => :amount?
  validates :organization_id, :presence => true, :numericality => true

  def amount?()
    if self.amount.blank? == false
      true
    else
      false
    end
  end

end
