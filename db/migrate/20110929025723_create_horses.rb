class CreateHorses < ActiveRecord::Migration
  def self.up
    create_table :horses do |t|
      t.string :reg_name
      t.string :barn_name
      t.string :notes
      t.integer :customer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :horses
  end
end
