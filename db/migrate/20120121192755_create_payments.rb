class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.date :date
      t.string :payment_type
      t.string :notes
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :invoice_id

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
