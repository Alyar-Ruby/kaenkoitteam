class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :kaenko_currency
      t.string :order
      t.decimal :amount
      t.decimal :fee_percent
      t.decimal :fee_value
      t.string :batch_id
      t.string :status
      t.text :note
      t.references :account
      t.references :user
      t.timestamps
    end
  end
end
