class AccountChatsController < ApplicationController
  before_action :chat_window_list, except: [:destroy]
  
  def new
    if session[:chat_accounts].present?
      if !session[:chat_accounts].include?(params[:account_id].to_i)
        (session[:chat_accounts] ||=[]) << params[:account_id].to_i   
      end
    else
    (session[:chat_accounts] ||= []) << params[:account_id].to_i   
    end

  end

  def create
    #raise params.inspect
    @recipient = Account.find(params[:account_id])
    uniq = Digest::MD5.hexdigest(Time.now.to_f.to_s+"_s_"+current_user.id.to_s)

    if @recipient.present? 
      if params[:message].present?
        msg = params[:message]
      account_list = [params[:account_id].to_i, current_user.account.id].sort!.join("")
      cnv = Conversation.where("accounts = ?", account_list).first
      @cnv = cnv.present? ? cnv : Conversation.new(title: uniq, accounts: account_list )

        if @cnv.save
          @cnv_msg = @cnv.conversation_messages.create(
              user_id: current_user.id, 
              account_id: current_user.account.id, 
              message: msg
            )  
          conversation_user= @cnv_msg.conversation_users.create(
                conversation_id: @cnv.id,
                user_id: current_user.id, 
                account_id: current_user.account.id, 
                archive: false, 
                is_read: true
            )
            if @cnv_msg.save
              @cnv_user = @cnv_msg.conversation_users.create(
                conversation_id: @cnv.id,
                user_id: "", archive: false, account_id: (@recipient.id) )
            end

          #@conversation_messages = @conversation.conversation_messages
          #@messages =  current_user.account.conversation_users.inbox.group("conversation_id").count
          #@messages = Hash[@messages.sort.reverse]
          
        else
          @error = @conversation.errors.full_messages
        end
      else
        @error = "Please enter message."
      end
    else
      @error = "Sorry recipient not present!"
    end
    #raise @cnv_msg.inspect
 end

 def destroy
  session[:chat_accounts].delete(params[:account_id].to_i)  if session[:chat_accounts].present?
  @available_chat_box = session[:chat_accounts]
  #raise  @available_chat_box.inspect
  @account = Account.find_by_id(params[:account_id])
 end

 def load_message
    @account = Account.find(params[:id])
    account_list = [@account.id, current_user.account.id].sort!.join("")
    @cnv = Conversation.where("accounts = ?", account_list).first 
    @messages =  @cnv.conversation_users.where("account_id =? and archive =? and is_deleted =? ", 
      current_user.account.id, false, false).order("created_at desc").page(params[:page]).per(6) 
    #raise @messages.inspect
 end

 def load_search_msg
    @account = Account.find(params[:id])
    account_list = [@account.id, current_user.account.id].sort!.join("")
    @cnv = Conversation.where("accounts = ?", account_list).first 
    if @cnv.present?
      @messages =  @cnv.conversation_users.where("account_id =? and archive =? and is_deleted =? ", 
      current_user.account.id, false, false).order("created_at desc")
    else
      @messages = []
    end
 end



private

def chat_window_list
 @account = Account.find(params[:account_id])
 #raise params.inspect
  account_list = [params[:account_id].to_i, current_user.account.id].sort!.join("")
  @cnv = Conversation.where("accounts = ?", account_list).first
  if @cnv.present?
    @messages =  @cnv.conversation_users.where("account_id =? and archive =? and is_deleted =? ", current_user.account.id, false, false).order("created_at asc")
  else
    @messages = []
  end
end

end
