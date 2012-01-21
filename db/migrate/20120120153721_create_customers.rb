class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :home
      t.string :cell
      t.string :work
      t.string :email
      t.integer :active
      t.string :delivery_method
      t.integer :auto_invoice
      t.integer :organization_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
