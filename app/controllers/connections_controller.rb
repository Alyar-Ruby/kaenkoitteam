class ConnectionsController < ApplicationController
	respond_to :js, :json, :html
	def index
		@connections = Connection.user_all_connection(current_user.account)
	end

	def pending_connection
		@pending_connections = Connection.where("to_account_id = ?  and status =?", current_user.account.id, "Pending")
	end

	def create
		to_account = Account.find_by_id(params[:to_account_id])

    @c1 = Connection.where(from_user_id: current_user.id, to_user_id: "", from_account_id: current_user.account.id, to_account_id: to_account.id)
    @c2 = Connection.where(to_user_id: current_user.id, from_user_id: "", from_account_id: to_account, to_account_id: current_user.account.id)
   
    if !@c1.present? and !@c2.present?
    	
      @connection = Connection.new(from_user_id: current_user.id, to_user_id: "", 
      	from_account_id: current_user.account.id, to_account_id: to_account.id)
      if @connection.save
        KaenkoNotification.create(:from_user_id=>current_user.id, :to_user_id=>params[:to_user], 
          :message=>"connection_invitation", roleable_type: "Connection" , 
          	roleable_id: @connection.id , :url=> social_user_path(@connection.from_account_id), from_account_id: current_user.account.id, 
          	to_account_id: to_account.id )
      end
    end
		respond_with(@connection)
	end

	def approve_reject
		if current_user.is_admin == true || current_user.user_permission("Accept Connections") == true
			@permission = true
			@connection = Connection.find(params[:id])
			@notification = KaenkoNotification.find(params[:nid])
			@nid = @notification.id
			if params[:_action] == "accept"
				if @connection.update_attributes(status: "Approved")
					@notification.update_attributes(message: "is now a Connection")
					KaenkoNotification.create(:from_user_id=>current_user.id, 
						:to_user_id=>@connection.from_user_id,
						:message=>"is now a Connection", 
						:url=> social_user_path(@connection.to_account_id), from_account_id: @notification.to_account_id,
						 to_account_id: @notification.from_account_id )
				end
			else
				if @connection.destroy
					@notification.destroy
					@reject = "reject"
				end
			end
		else
			@permission = false
		end
	end

end
