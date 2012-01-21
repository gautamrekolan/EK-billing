class CreateHorses < ActiveRecord::Migration
  def self.up
    create_table :horses do |t|
      t.string :reg_name
      t.string :barn_name
      t.string :breed
      t.integer :age
      t.string :notes
      t.integer :organization_id
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :horses
  end
end
