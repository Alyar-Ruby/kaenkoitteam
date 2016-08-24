class AddAccountStatusDocumentToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :account_status_document, :string
  end
end
