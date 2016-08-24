class AddCurrencyStatusToInvoice < ActiveRecord::Migration
  def change
  	add_column :invoices, :kaenko_currency_id, :integer
  	add_column :invoices, :status, :string
  end
end
