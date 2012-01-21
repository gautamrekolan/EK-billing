class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer :status_code
      t.string :status
      t.integer :invoice_id

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
