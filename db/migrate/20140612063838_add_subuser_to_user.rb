class AddSubuserToUser < ActiveRecord::Migration
  def change
  	add_column :users, :subuser, :boolean , default: false
  end
end
