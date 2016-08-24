class AddTransactionFromIdToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :transaction_from_id, :integer
    add_column :transactions, :transaction_to_id, :integer
    remove_column :transactions, :roleable_id
    remove_column :transactions, :roleable_type
  end
end
