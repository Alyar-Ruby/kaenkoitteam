class AddActiveToUserAndAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :active, :boolean, :default=>true
    add_column :users, :active, :boolean, :default=>true
  end
end
