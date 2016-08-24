class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :account_number
      t.references :roleable, polymorphic: true
      t.boolean :approved
      t.boolean :premium, :default=>false
      t.boolean :verified, :default=>false
      t.string :pin, :limit=>4
      t.integer :user_security_question_id
      t.string :security_question_answer
      t.string :search_by      
      t.decimal :platform_limit
      t.references :kaenko_currency
      t.timestamps
    end
  end
end
