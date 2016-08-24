class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
    	t.integer :from_user_id
    	t.integer :to_user_id
    	t.string :status, default: "Pending"
      t.timestamps
    end
  end
end
