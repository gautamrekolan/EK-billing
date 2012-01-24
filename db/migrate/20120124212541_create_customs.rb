class CreateCustoms < ActiveRecord::Migration
  def self.up
    create_table :customs do |t|
      t.integer :organization_id
      t.string  :checks_payable_to
      t.string  :signoff_line
      t.integer :customer_info_check
      t.string  :logo_extension
      t.timestamps
    end
  end

  def self.down
    drop_table :customs
  end
end
