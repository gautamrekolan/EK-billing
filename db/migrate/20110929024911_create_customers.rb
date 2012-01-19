class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.string :delivery_method
      t.integer :auto_invoice
      t.integer :active
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
