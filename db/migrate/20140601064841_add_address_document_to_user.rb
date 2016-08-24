class AddAddressDocumentToUser < ActiveRecord::Migration
  def change
  	add_column :users, :address_document, :string
  end
end
