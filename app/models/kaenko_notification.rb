class KaenkoNotification < ActiveRecord::Base
  belongs_to :from_user, :class_name=>"User", :foreign_key=>"from_user_id"
  belongs_to :to_user, :class_name=>"User", :foreign_key=>"to_user_id"
  belongs_to :roleable, polymorphic: true

  scope :notification_all, ->(_user){where("to_account_id = ?", _user.account.id).order('created_at desc')}
  scope :unread_notification, ->(_user){where("to_account_id = ? and checked = ?", _user.account.id, false).order('created_at desc')}


  def created_at
    super.in_time_zone if super
  end

  def updated_at
    super.in_time_zone if super
  end
  
end
