class CreateUserReferrals < ActiveRecord::Migration
  def change
    create_table :user_referrals do |t|
    	t.references :user
    	t.string	:email
    	t.boolean :status, default: false
      t.timestamps
    end
  end
end
