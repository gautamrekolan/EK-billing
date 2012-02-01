class AddCustomerIdToUsers < ActiveRecord::Migration
  def self.up
    add_column(:users, :customer_id, :integer)
  end

  def self.down
    remove_column(:users, :customer_id)
  end
end
