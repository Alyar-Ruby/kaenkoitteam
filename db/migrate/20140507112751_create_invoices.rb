class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :user
    	t.string :number
    	t.date :invoice_date
    	t.date :due_date
    	t.string :receipent
    	t.text :terms_conditions
    	t.decimal :subtotal, default: 0
    	t.decimal :shipping, default: 0
    	t.decimal :discount, default: 0
    	t.decimal :total, default: 0
      t.timestamps
    end
  end
end
