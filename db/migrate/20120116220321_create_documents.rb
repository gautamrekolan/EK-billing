class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :description
      t.string :notes
      t.string :filename
      t.string :extension
      t.integer :customer_id
      t.integer :horse_id

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
