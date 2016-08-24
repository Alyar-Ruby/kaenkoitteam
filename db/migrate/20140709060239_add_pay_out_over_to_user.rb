class AddPayOutOverToUser < ActiveRecord::Migration
  def change
  	add_column :users, :pay_out_over, :decimal, default: 0.0
  end
end
