# encoding: utf-8
class ChatController < WebsocketRails::BaseController
before_filter :authenticate_user!
  include ActionView::Helpers::SanitizeHelper
 
  def initialize_session
    puts "Session Initialized\n"
  end

  def self.all_user
    connection_store[:user]
  end
  
  def system_msg(ev, msg)
    broadcast_message ev, { 
      #user_name: 'system', 
      #my modification
      user_name: current_user.id, 
      id: current_user.id,
      received: Time.now.to_s(:short), 
      msg_body: msg
    }
  end
  
  def user_msg(ev, msg)
    UserMessage.create(:user_id => current_user.id, :msg => msg)
    broadcast_message ev, { 
      user_name:  connection_store[:user][:user_name], 
      received:   Time.now.to_s(:short), 
      msg_body:   ERB::Util.html_escape(msg)
      }
  end
  
  def client_connected
    #system_msg :new_message, "client #{client_id} connected"
  end
  
  def new_message
    user_msg :new_message, message[:msg_body].dup
  end
  
  def new_user
    status = (current_user.online_status == false) ? "offline" : "online"
    connection_store[:user] = { account_id: current_user.account.id, user_name: current_user.name, id: current_user.id, img: current_user.image_url(:profile), status: status }
    broadcast_user_list
  end
  
  def change_username
    connection_store[:user][:user_name] = sanitize(message[:user_name])
    broadcast_user_list
  end

  def offline_user
    
    #connection_store[:user] = nil

    connection_store[:user] = { account_id: current_user.account.id, user_name: current_user.name, id: current_user.id, img: current_user.image_url(:profile), status: "offline" }
    current_user.update_column(:online_status, false)
    
    #system_msg "client #{client_id} disconnected"
    broadcast_user_list
  end

  def offline_browser_close
    connection_store[:user] = { account_id: current_user.account.id, user_name: current_user.name, id: current_user.id, img: current_user.image_url(:profile), status: "offline" }
    broadcast_user_list
  end

   def online_user
    #connection_store[:user] = nil
    connection_store[:user] = { account_id: current_user.account.id, user_name: current_user.name, id: current_user.id, img: current_user.image_url(:profile), status: "online" }
    #system_msg "client #{client_id} disconnected"
    current_user.update_column(:online_status, true)
    broadcast_user_list
  end
  
  def delete_user
    #connection_store[:user] = nil
    connection_store[:user] = { account_id: current_user.account.id, user_name: current_user.name, id: current_user.id, img: current_user.image_url(:profile), status: "offline" }
    #system_msg "client #{client_id} disconnected"
    #puts "==============================Browser close delete======================"
    #puts connection_store
    #puts "================================================================="
    broadcast_user_list
  end
  
  def broadcast_user_list
    users = connection_store.collect_all(:user)
    #puts "=============================================="
    #puts users
    #puts "==============================================="
    broadcast_message :user_list, users
  end
  
end
