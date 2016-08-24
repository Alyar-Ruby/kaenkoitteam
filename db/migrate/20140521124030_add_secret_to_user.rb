class AddSecretToUser < ActiveRecord::Migration
  def change
  	add_column :users, :secret_question_answer, :text
  	remove_column :accounts, :security_question_answer
  end
end
