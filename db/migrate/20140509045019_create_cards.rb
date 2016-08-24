class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
    	t.references :user
    	t.string :name
    	t.string :card_type
    	t.date :expiry_date
    	t.boolean :status, default: false
    	t.boolean :primary, default: false

      t.timestamps
    end
  end
end
