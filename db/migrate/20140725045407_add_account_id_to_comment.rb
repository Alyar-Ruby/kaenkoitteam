class AddAccountIdToComment < ActiveRecord::Migration
  def change
  	add_column :comments , :account_id , :integer
  end
end
