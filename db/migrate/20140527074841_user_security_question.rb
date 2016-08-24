class UserSecurityQuestion < ActiveRecord::Migration
  def change
  	add_column :users, :user_security_question_id, :integer
  	add_column :users, :pin, :string
  	remove_column :accounts, :user_security_question_id
  	remove_column :accounts, :pin
  end
end
