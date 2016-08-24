class AddTransactionIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :transaction_id, :string
  end
end
