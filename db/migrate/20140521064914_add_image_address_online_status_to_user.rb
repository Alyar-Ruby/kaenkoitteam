class AddImageAddressOnlineStatusToUser < ActiveRecord::Migration
  def change
  	add_column :users, :image, :string
  	add_column :users, :online_status, :boolean, default: false
  	add_column :users, :address_verified, :boolean, default: false
  end
end
