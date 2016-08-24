class AddCommissionToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :commission, :decimal
  end
end
