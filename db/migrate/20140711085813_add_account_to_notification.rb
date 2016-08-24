class AddAccountToNotification < ActiveRecord::Migration
  def change
  	add_column :kaenko_notifications, :from_account_id, :integer
  	add_column :kaenko_notifications, :to_account_id, :integer
  end
end
