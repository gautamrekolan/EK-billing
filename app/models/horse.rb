# == Schema Information
#
# Table name: horses
#
#  id          :integer(4)      not null, primary key
#  reg_name    :string(255)
#  barn_name   :string(255)
#  notes       :string(255)
#  customer_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Horse < ActiveRecord::Base
  belongs_to  :customer
  has_many    :items,     :dependent => :delete_all
  has_many    :autos,     :dependent => :delete_all
  has_many    :documents, :dependent => :delete_all, :order => "description asc"

  attr_accessible :reg_name, :barn_name, :notes, :customer_id

  validates :reg_name,    :length => { :maximum => 50 }
  validates :barn_name,   :presence => true, :length => { :maximum => 50 }
  validates :notes,       :length => { :maximum => 500 }
  validates :customer_id, :presence => true, :numericality => true
end
