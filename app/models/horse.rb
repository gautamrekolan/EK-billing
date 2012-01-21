class Horse < ActiveRecord::Base

  belongs_to  :customer
  belongs_to  :organization
  has_many    :autos, :dependent => :delete_all
  has_many    :items, :dependent => :delete_all

  validates :reg_name,    :length => { :maximum => 50 }
  validates :barn_name,   :presence => true, :length => { :maximum => 50 }
  validates :notes,       :length => { :maximum => 500 }
  validates :customer_id, :presence => true, :numericality => true

end
