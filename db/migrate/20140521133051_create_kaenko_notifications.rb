class CreateKaenkoNotifications < ActiveRecord::Migration
  def change
    create_table :kaenko_notifications do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :message
      t.string :url
      t.timestamps
    end
  end
end
