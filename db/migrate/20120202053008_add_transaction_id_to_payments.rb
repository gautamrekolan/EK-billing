class AddTransactionIdToPayments < ActiveRecord::Migration
  def self.up
    add_column(:payments, :transaction_id, :integer)
  end

  def self.down
    remove_column(:payments, :transaction_id)
  end
end
