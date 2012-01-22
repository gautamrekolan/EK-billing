class Horse < ActiveRecord::Base

  belongs_to  :customer
  belongs_to  :organization
  has_many    :autos, :dependent => :delete_all
  has_many    :items, :dependent => :delete_all

  validates :reg_name,        :length => { :maximum => 50 }
  validates :barn_name,       :presence => true, :length => { :maximum => 50 }
  validates :breed,           :length => { :maximum => 250 }
  validates :age,             :numericality => true, :if => :age?
  validates :notes,           :length => { :maximum => 250 }
  validates :organization_id, :presence => true, :numericality => true
  validates :customer_id,     :presence => true, :numericality => true

  def age?()
    if self.age.blank? == false
      true
    else
      false
    end
  end

end
