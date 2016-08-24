class AddAccountToConversation < ActiveRecord::Migration
  def change
  	rename_column :conversations, :users, :accounts 
  	add_column :conversation_users, :account_id, :integer
  	add_column :conversation_messages, :account_id, :integer
  end
end
