class CreateConversationMessages < ActiveRecord::Migration
  def change
    create_table :conversation_messages do |t|
      t.references :conversation
      t.text :message
      t.references :user
      t.timestamps
    end
  end
end
