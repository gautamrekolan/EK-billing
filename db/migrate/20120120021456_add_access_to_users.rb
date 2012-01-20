class AddAccessToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :access, :string
  end

  def self.down
    remove_column :users, :access
  end
end
