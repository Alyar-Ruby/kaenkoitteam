class CreateMessageImages < ActiveRecord::Migration
  def change
    create_table :message_images do |t|
    	t.references :conversation_message
    	t.string :attachment
    	t.string :attachment_type
      t.timestamps
    end
  end
end
