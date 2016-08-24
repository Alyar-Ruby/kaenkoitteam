class AddRoleableToNotification < ActiveRecord::Migration
  def change
  	add_column :kaenko_notifications , :roleable_type, :string
  	add_column :kaenko_notifications , :roleable_id, :integer
  end
end
