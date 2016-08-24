class ChangeColumnNotificationMessage < ActiveRecord::Migration
  def change
  	change_column :kaenko_notifications, :message , :text
  end
end
