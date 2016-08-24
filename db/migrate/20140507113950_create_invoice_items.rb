class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.references :invoice
    	t.string :item_name
    	t.integer :quantity
    	t.decimal :unit_price, default: 0
    	t.string :tax_type
    	t.decimal :amount, default: 0
    	t.references :kaenko_currency
      t.timestamps
    end
  end
end
