class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
    	t.references :user
    	t.string :name
    	t.references :kaenko_currency
    	t.boolean :status, default: false
    	t.boolean :primary, default: false
      t.timestamps
    end
  end
end
