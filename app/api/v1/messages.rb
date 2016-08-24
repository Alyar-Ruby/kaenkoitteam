module API
  module V1
    class Messages < Grape::API
      include API::V1::Defaults
      resources :messages do
      	desc "Creates and returns access_token if valid login"
				params do
					#requires :email, type: String, desc: "Username or email address"
					#requires :password, type: String, desc: "Password"
				end
        desc "Return a list of inbox messages"        
        get  do
        	authenticate!
        	json_message = []

          messages = current_user.user_messages.where(
          							"trash = ? and archive = ?", false, false
          						).group("message_id").count
          messages.each do |id, value|
          	message = Message.find(id)
          	message_detail = message.message_details.order("created_at desc").first
          	json_message << {
          		user_name: message_detail.user.email,
          		subject: message.subject,
          		body: message_detail.content,
          		message_count: message.message_details.count
          	}
          end
          json_message
        end
        desc "Return a list of sent messages"        
		    get :sent_message do
		     	authenticate!
		     	sent_messages = current_user.message_details
		     															.where("trash = ? and archive = ?", false, false)
                                      .group("message_id").count
		     	sent_json_message = []
		     	sent_messages.each do |id, value|
		     		message = Message.find(id)	
		     		message_detail = message.message_details.order("created_at desc").first
		     		if message && message.present?
		     			sent_json_message << {
			     			to: message_detail.user_messages.collect{|m| m.user.email} ,
	          		subject: message.subject,
	          		body: message_detail.content,
	          		message_count: message.message_details.count
		     			}
		     		end
		     	end
		     	sent_json_message
		     end #===== end sent_message ====
		     
		    desc "Return a list of trash messages"        
		    get :trash_message do
					authenticate!
					messages = current_user.user_messages.where("trash = ?",  true)
                								               .group("message_id").count
					trash_message = []
					messages.each do |id, value|
          	message = Message.find(id)
          	message_detail = message.message_details.order("created_at desc").first
          	trash_message << {
          		user_name: message_detail.user.email,
          		subject: message.subject,
          		body: message_detail.content,
          		message_count: message.message_details.count
          	}
          end
					trash_message
		    end #==== end trash ====
		    desc "archive message"        
		    get :archive_message do
		    	authenticate!
		    	messages = current_user.user_messages.where("archive = ?",  true)
                								               .group("message_id").count
          archive_message = []
        	messages.each do |id, value|
          	message = Message.find(id)
          	message_detail = message.message_details.order("created_at desc").first
						
						archive_message << {
							user_name: message_detail.user.email,
	        		subject: message.subject,
	        		body: message_detail.content,
	        		message_count: message.message_details.count
						}
					end
					archive_message
		    end #=== end archive message====
		    desc "Compose message" 
		    #==========================
		    #==== compose message =====
		    #==========================       
		    post :compose do
		    	@message = Message.user_message(params[:user_email].split(","))
		    	params_hash = {}
		    	content_hash = {}
		    	content_hash["content"] = params[:body]
		    	content_hash["user_id"] = current_user.id
		    	n_attr = {}
		    	n_attr["0"] = content_hash
		    	params_hash["subject"] = params[:subject]
		    	params_hash["message_details_attributes"] = n_attr
		    	msg = ""
			    user_email = []
			  	if @message == false
			  		msg = "None of the user registered to kaenko account to send message."
			  	else
			    	@message = Message.new(params_hash)
						if @message.save
							 message_detail_id = @message.message_details.first.id
							if params[:user_email].present?
								 params[:user_email].split(",").each do |email|
								 	u = User.find_by_email(email.downcase.strip)
								 	if u && u.present?
								 		user_message = @message.message_details.first.user_messages.new(
								 																								user_id: u.id, 
								 																								message_id: @message.id
								 																							)
								 		user_email << email if user_message.save
								 	end
								 end
							end
							msg = "Message has been sent to #{user_email.join(',')}."
						else
							msg = "Unable to compose message."
						end
					end
					msg
		    end	   #==== end  compose message ====
		    get :trash_inbox_message do
		    	message = current_user.user_messages
		    												.update_all({trash: true},
		    							 						["user_messages.message_id 
		    							 						IN (#{ params[:message_ids].split(',').join(',')})"]
		    							 					)
		     message = message > 0 ? "Message has been trash" : "Unable to trash message"
		    end #====== end trash inbox========
		   get :archive_inbox_message do
		    	message = current_user.user_messages
		    												.update_all({archive: true},
		    													["user_messages.message_id IN
		    												 	(#{ params[:message_ids].split(',').join(',')})"]
		    												 )
		    	message = message > 0 ? "Message has been archived" : "Unable to archive message"
		    end #====== end archive inbox========
		    get :trash_sent_message do
		    	message = current_user.message_details
		    												.update_all({trash: true}, 
		    													["message_details.message_id IN 
		    													(#{ params[:message_ids].split(",").join(',')})"]
		    												) 
		    	message = message > 0 ? "Message has been trash" : "Unable to trash message"
		    end #==== end trash sent message ======
		    
		     get :archive_sent_message do
		    	message = current_user.messages_details
		    												.update_all({archive: true},
		    													["messages_details.message_id IN 
		    													(#{ params[:message_ids].split(",").join(',')})"]
		    												) 
		    	message = message > 0 ? "Message has been archived" : "Unable to trash message"
		    end #==== end trash sent message ======
		    
      end #=== end resource ====
    end #=== end class =====
  end #==== end module v1=====
end #==== end module api====
