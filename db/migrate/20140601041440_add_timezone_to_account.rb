class AddTimezoneToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :time_zone, :string
  end
end
