class ChangePaymentMethodColumnToTypeColumn < ActiveRecord::Migration
  def self.up
    remove_column :payments, :method
    add_column :payments, :payment_type, :string
  end

  def self.down
    remove_column :payments, :payment_type
  end
end
