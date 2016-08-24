class AddAccountDocumentToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :account_document, :string
  	add_column :accounts, :account_id_document, :string
  end
end
