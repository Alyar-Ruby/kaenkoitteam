class ChangeReferralStatus < ActiveRecord::Migration
  def change
  	change_column :user_referrals, :status, :string, default: "Invited"
  	add_column :user_referrals, :current_earnings, :decimal, default: 0.00
  end
end
