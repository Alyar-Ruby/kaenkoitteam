class AddRoleableToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :roleable_id, :integer #add role for bank and debit/credit card
    add_column :transactions, :roleable_type, :string
  end
end
