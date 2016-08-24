class AddAccountToConnection < ActiveRecord::Migration
  def change
  	add_column :connections, :from_account_id, :integer
  	add_column :connections, :to_account_id, :integer
  end
end
