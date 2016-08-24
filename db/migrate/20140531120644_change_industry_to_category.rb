class ChangeIndustryToCategory < ActiveRecord::Migration
  def change
  	remove_column :businesses, :industry
  	add_column :businesses, :category_id, :integer
  	add_column :businesses, :sub_category_id, :integer
  end
end
