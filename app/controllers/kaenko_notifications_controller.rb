class KaenkoNotificationsController < ApplicationController
  
  def index
    @notifications = KaenkoNotification.notification_all(current_user)
    render :layout=>false
  end

  def notification_check
  	@notifications = KaenkoNotification.update_all({checked: true}, 
                        ["to_account_id =?", current_user.account.id])
    render :text => :success
  end
  def total_notification
    @notifications = KaenkoNotification.notification_all(current_user)
    render :text => @notifications.size
  end

  def unread_notification
    @notifications = KaenkoNotification.unread_notification(current_user)
    render :layout=>false 
  end

  def delete_notification
  	@notifications = KaenkoNotification.notification_all(current_user)

  	@notifications.each do |notification|
  		role = notification.roleable
  		if notification.roleable_type == "Connection" 
  			notification.destroy
  		elsif notification.checked == true
  			notification.destroy
  		end
  	end
  end
  
end
