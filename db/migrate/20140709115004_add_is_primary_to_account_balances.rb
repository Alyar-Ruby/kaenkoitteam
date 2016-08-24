class AddIsPrimaryToAccountBalances < ActiveRecord::Migration
  def change
  	add_column :account_balances, :is_primary, :boolean, default: false
  	change_column :account_balances, :balance, :decimal, default: 0.0
  end
end
