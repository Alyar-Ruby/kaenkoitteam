class CreateFeesUploads < ActiveRecord::Migration
  def change
    create_table :fees_uploads do |t|
      t.string :account
      t.string :payment_option
      t.string :account_type
      t.decimal :brute_fee_percent
      t.decimal :brute_fee_value
      t.decimal :total_fee_percent
      t.decimal :total_fee_value
      t.decimal :our_margin
      t.decimal :limits
      t.string :provider
      t.boolean :refund
      t.timestamps
    end
  end
end
