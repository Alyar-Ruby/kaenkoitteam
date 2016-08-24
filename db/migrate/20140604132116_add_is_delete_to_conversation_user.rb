class AddIsDeleteToConversationUser < ActiveRecord::Migration
  def change
  	add_column :conversation_users, :is_deleted, :boolean, default: false
  end
end
