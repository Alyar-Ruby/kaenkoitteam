class AddEmailRegionToBusiness < ActiveRecord::Migration
  def change
  	add_column :businesses, :email, :string
  	add_column :businesses, :region, :string
  end
end
