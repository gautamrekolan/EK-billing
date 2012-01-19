class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :unique => true
      t.string :email
      t.string :name
      t.string :encrypted_password
      t.string :salt
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
