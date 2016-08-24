class CreateUserCapabilities < ActiveRecord::Migration
  def change
    create_table :user_capabilities do |t|
    	t.references :user
    	t.references :capability
    	t.decimal :daily_limit
      t.timestamps
    end
  end
end
