class AddStatusToNotifications < ActiveRecord::Migration
  def change
    add_column :kaenko_notifications, :checked, :boolean, :default=>false
  end
end
