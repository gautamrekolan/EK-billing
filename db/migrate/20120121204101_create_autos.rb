class CreateAutos < ActiveRecord::Migration
  def self.up
    create_table :autos do |t|
      t.date :start_date
      t.date :end_date
      t.integer :add_day
      t.string :description
      t.integer :quantity
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :customer_id
      t.integer :horse_id

      t.timestamps
    end
  end

  def self.down
    drop_table :autos
  end
end
