class CreateConversationUsers < ActiveRecord::Migration
  def change
    create_table :conversation_users do |t|
      t.references :conversation
      t.references :conversation_message
      t.references :user
      t.boolean :archive
      t.timestamps
    end
  end
end
