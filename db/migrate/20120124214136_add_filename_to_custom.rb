class AddFilenameToCustom < ActiveRecord::Migration
  def self.up
    add_column(:customs, :logo_filename, :string)
  end

  def self.down
    remove_column(:customs, :logo_filename)
  end
end
