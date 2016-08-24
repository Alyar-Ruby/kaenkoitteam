class AddAccountIdToBank < ActiveRecord::Migration
  def change
    add_column :banks, :account_id, :integer
    add_column :banks, :processing_time, :string
    add_column :banks, :country, :string
  end
end
