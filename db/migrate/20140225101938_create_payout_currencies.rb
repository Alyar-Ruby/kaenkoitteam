class CreatePayoutCurrencies < ActiveRecord::Migration
  def change
    create_table :payout_currencies do |t|
    	t.references :fees_redemption
    	t.references :kaenko_currency
      t.timestamps
    end
  end
end
