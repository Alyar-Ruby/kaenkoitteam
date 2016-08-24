class AddSuspendAndSecurityPinToUser < ActiveRecord::Migration
  def change
  	add_column :users, :suspend , :boolean, default: false
  	add_column :users, :security_pin, :string, :limit => 6
  end
end
