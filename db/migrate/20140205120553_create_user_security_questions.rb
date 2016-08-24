class CreateUserSecurityQuestions < ActiveRecord::Migration
  def change
    create_table :user_security_questions do |t|
      t.string :name, :null => false
    end
  end
end
