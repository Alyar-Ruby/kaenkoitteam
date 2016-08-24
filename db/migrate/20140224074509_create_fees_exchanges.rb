class CreateFeesExchanges < ActiveRecord::Migration
  def change
    create_table :fees_exchanges do |t|
      t.integer :from_currency_id
      t.integer :to_currency_id
      t.decimal :fee_percent
      t.decimal :fee_value
      t.decimal :our_fee
      t.decimal :fx_fee
      t.string :provider
      t.decimal :limit_pd
      t.string :exchange_group
      t.string :account_type
      t.timestamps
    end
  end
end
