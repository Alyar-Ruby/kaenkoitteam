class AddFieldsToPremiumRequest < ActiveRecord::Migration
  def change
    add_column :premium_requests, :status, :string, :limit=>10, :default=>"pending"
    add_column :premium_requests, :comments, :string
  end
end
