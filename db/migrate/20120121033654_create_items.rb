class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :category_id
      t.string :description
      t.integer :quantity
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :organization_id
      t.integer :customer_id
      t.integer :horse_id
      t.integer :invoice_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
