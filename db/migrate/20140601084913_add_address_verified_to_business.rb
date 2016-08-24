class AddAddressVerifiedToBusiness < ActiveRecord::Migration
  def change
  	add_column :businesses, :address_document , :string
  	add_column :businesses, :address_verified, :boolean, :default => false
  	add_column :businesses, :business_document, :string
  	add_column :businesses, :business_verified, :boolean, :default => false
  end
end
