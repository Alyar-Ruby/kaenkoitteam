class CreateDisputes < ActiveRecord::Migration
  def change
    create_table :disputes do |t|
      t.date :must_reply_before
      t.references :user
      t.integer :from_account_id
      t.integer :to_account_id
      t.references :transaction
      t.references :kaenko_currency
      t.string :reason
      t.decimal :amount, default: 0.0
      t.boolean :is_resolved, default: false
      t.string :document
      t.text :message
      t.boolean :is_shipment_pay, default: false
      t.boolean :is_partial_refund, default: false
      t.timestamps
    end
  end
end
