class CreateAccountBalances < ActiveRecord::Migration
  def change
    create_table :account_balances do |t|
      t.references :account
      t.decimal :balance
      t.references :kaenko_currency
      t.timestamps
    end
  end
end
