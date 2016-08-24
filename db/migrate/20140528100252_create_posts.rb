class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.integer :from_user_id
    	t.integer :to_user_id
    	t.text 		:title
      t.timestamps
    end
  end
end
