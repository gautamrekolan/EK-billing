class Category < ActiveRecord::Base
  has_many :items
  has_many :autos
end
