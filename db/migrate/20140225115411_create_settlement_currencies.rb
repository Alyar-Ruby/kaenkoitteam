class CreateSettlementCurrencies < ActiveRecord::Migration
  def change
    create_table :settlement_currencies do |t|
    	t.references :fees_upload
    	t.references :kaenko_currency
      t.timestamps
    end
  end
end
