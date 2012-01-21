class Category < ActiveRecord::Base

  belongs_to :organization

  validates :category,        :presence => true
  validates :name,            :presence => true
  validates :organization_id, :presence => true, :numericality => true

end
