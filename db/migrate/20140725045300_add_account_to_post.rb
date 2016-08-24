class AddAccountToPost < ActiveRecord::Migration
  def change
  	add_column :posts , :from_account_id , :integer
  	add_column :posts ,  :to_account_id , :integer
  end
end
