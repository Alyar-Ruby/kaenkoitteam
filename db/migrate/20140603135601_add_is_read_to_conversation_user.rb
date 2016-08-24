class AddIsReadToConversationUser < ActiveRecord::Migration
  def change
  	add_column :conversation_users, :is_read, :boolean, default: false
  end
end
