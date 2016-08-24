class AddTransactionRoleToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions,  :roleable_id, :integer
    add_column :transactions,  :roleable_type, :string
  end
end
