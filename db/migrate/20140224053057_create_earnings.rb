class CreateEarnings < ActiveRecord::Migration
  def change
    create_table :earnings do |t|
      t.references :account
      t.references :user
      t.references :kaenko_currency
      t.decimal :amount
      t.string :transaction_type
      t.decimal :fee_earned_percent 
      t.decimal :fee_earned_value
      t.string :batch_id
      t.string :note
      t.timestamps
    end
  end
end
