class AddLastSignInToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :last_sign_in, :integer
  end
end
