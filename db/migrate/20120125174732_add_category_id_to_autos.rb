class AddCategoryIdToAutos < ActiveRecord::Migration
  def self.up
    add_column(:autos, :category_id, :integer)
  end

  def self.down
    remove_column(:autos, :category_id)
  end
end
