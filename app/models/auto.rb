class Auto < ActiveRecord::Base

  belongs_to :customer
  belongs_to :horse

end
