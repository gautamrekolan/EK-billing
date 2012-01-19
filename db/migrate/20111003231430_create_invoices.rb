class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.date :issued_date
      t.date :due_date
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :notes
      t.integer :status_code
      t.string :status
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
