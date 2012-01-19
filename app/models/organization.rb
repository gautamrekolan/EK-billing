class Organization < ActiveRecord::Base

  validates :name, :presence => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :zip, :presence => true
  validates :phone, :presence => true
  validates :email, :presence => true
  validates :website, :presence => true
  validates :contact, :presence => true

end
