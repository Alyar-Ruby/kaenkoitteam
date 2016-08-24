class CreateRequestPayments < ActiveRecord::Migration
  def change
    create_table :request_payments do |t|
    	t.references :user
    	t.string :request_to
    	t.decimal :amount
    	t.references :kaenko_currency
    	t.string :title
    	t.text :memo
      t.timestamps
    end
  end
end
