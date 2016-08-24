class AddBankAccountToBank < ActiveRecord::Migration
  def change
    add_column :banks, :account_number, :string
  end
end
