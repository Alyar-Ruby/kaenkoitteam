class AddUsersToConversation < ActiveRecord::Migration
  def change
  	add_column :conversations, :users, :string
  end
end
