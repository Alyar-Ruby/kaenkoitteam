class CreateBusinessWebsites < ActiveRecord::Migration
  def change
    create_table :business_websites do |t|
    	t.references :business
    	t.string :title
    	t.string :website_url
    	t.boolean :is_primary, 	default: false
      t.timestamps
    end
  end
end
