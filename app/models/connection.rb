class Connection < ActiveRecord::Base
	belongs_to :from_user, :class_name=>"User", :foreign_key=>"from_user_id"
  belongs_to :to_user, :class_name=>"User", :foreign_key=>"to_user_id"

  belongs_to :from_account, :class_name=>"Account", :foreign_key=>"from_account_id"
  belongs_to :to_account, :class_name=>"Account", :foreign_key=>"to_account_id"
 
  scope :user_all_connection, ->(_account){where("(from_account_id = ? and status = ?) or (to_account_id = ? and status =?)", 
  													_account.id, "Approved", _account.id, "Approved")}
end
