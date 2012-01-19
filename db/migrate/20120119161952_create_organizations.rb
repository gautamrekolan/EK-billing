class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.string :website
      t.string :contact
      t.timestamps
    end
  end

  def self.down
    drop_table :organizations
  end
end
