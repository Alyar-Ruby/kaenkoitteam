class AddParentToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :parent_id, :integer
  end
end
