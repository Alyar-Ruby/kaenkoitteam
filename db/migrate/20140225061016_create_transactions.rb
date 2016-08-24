class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :from_account_id
      t.integer :to_account_id
      t.string :transaction_from
      t.string :transaction_to
      t.string :transaction_type
      t.references :kaenko_currency
      t.string :fee_payer
      t.decimal :amount
      t.decimal :fee_percent
      t.decimal :fee_value
      t.string :batch_id
      t.string :status
      t.text :note
      t.references :user
      t.timestamps
    end
  end
end
