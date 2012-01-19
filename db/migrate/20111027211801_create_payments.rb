class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :invoice_id
      t.integer :customer_id
      t.date :date_received
      t.string :payment_method
      t.string :payment_notes
      t.float :payment_amount, :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
