# encoding: utf-8
class MessagesController < ApplicationController
  autocomplete :user, :email, :display_value => :full_details, :extra_data => [:image, :name]
  respond_to :js, :html,:json
  before_action :unread_message
  before_action :msg_list_inbox, :only => [:index, :popup_messages, :reply,  :new,
                                          :show, :search_within_message]
  before_action :msg_list_archive, :only => [:show_archive]

  def msg_list_inbox
    @messages =  current_user.account.conversation_users.inbox.group("conversation_id").count
    @messages = Hash[@messages.sort.reverse]
    @latest_message = Array.new
    if @messages.size > 0
      @messages.each  do |id, v|  
      @latest_message << ConversationMessage.where(
            "conversation_id = ?",id).order("created_at desc").limit(1).first
      end
    end
    @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
  end
  
  def msg_list_archive
    @messages =  current_user.account.conversation_users.archive_msg.group("conversation_id").count
    @latest_message = Array.new
    @messages.each  do |id, v|  
    @latest_message << ConversationMessage.where(
          "conversation_id = ?",id).order("created_at desc").limit(1).first
    end
     @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse

  end
  

  def unread_message
    @unread_messages =  current_user.account.conversation_users.unread_message.group("conversation_id").count
  end
  
  def autocomplete_user_email
    term = params[:term]
    users = User.where('id <> ? AND email LIKE ?', current_user.id, "%#{term}%").order(:email).all
    render :json => users.map { |user| {:id => user.id, :label => user.full_details, :value => user.email} }
  end

 #  helper_method :mailbox, :conversation

  def total_messages
    @messages =  current_user.account.conversation_users.where("archive = ? and is_deleted = ? ", false, false).group("conversation_id").count
    render :json => @messages.size                                    
  end
  
  def popup_messages
    render :layout => false
  end
  
  def index
    @current_top_menu = "message"
  end
  
  def to_user
    #@users = User.where("email like ?", "%#{params[:q]}%")
     @users = Array.new
     connections = Connection.user_all_connection(current_user.account)
     connections.each{|c| @users << if (c.to_account.id != current_user.account.id) then c.to_account.id else c.from_account.id end}
      @accounts = Account.find_by_sql("
        (select accounts.* from accounts LEFT JOIN users ON users.account_id = accounts.id 
          where accounts.roleable_type = 'Personal' and accounts.id in (#{@users.join(",")}) and (users.first_name ILIKE '%"+ params[:q] +"%'
          or users.last_name ILIKE '%"+ params[:q] +"%' or split_part(users.email, '@', 1) ILIKE '%"+ params[:q] +"%') 
        )
      
        UNION

        (select accounts.* from accounts LEFT JOIN businesses ON accounts.roleable_id = businesses.id 
          where accounts.roleable_type = 'Business' and accounts.id in (#{@users.join(",")})
          and (businesses.organization_name ILIKE '%"+ params[:q] +"%' 
          or businesses.organization_url ILIKE '%"+ params[:q] +"%'
          or split_part(businesses.email, '@' , 1) ILIKE '%"+ params[:q] +"%' 
          or businesses.category_id in (select id from categories where name ILIKE '%"+ params[:q] +"%') 
          or businesses.sub_category_id in (select id from categories where name ILIKE '%"+ params[:q] +"%') )
        )")

     respond_to do |format|
       format.html
       format.json { render :json => @accounts.uniq.collect{|a| {name: a.display_name, id: a.id , 
        image_url: a.display_image, country: a.display_country_name, city: a.display_city, website: a.display_website } }}
     end
  end
 
  def create
    
    @error = ""
    recipient_emails = params[:recipients].split(",")
    @recipients = Account.where(id: recipient_emails).order("id asc").all
    uniq = Digest::MD5.hexdigest(Time.now.to_f.to_s+"_s_"+current_user.id.to_s)
    if @recipients.size > 0
      if params[:body].present?
        msg = params[:body]
      account_list = (@recipients.map(&:id) << current_user.account.id).sort!.join("")
      cnv = Conversation.where("accounts = ?", account_list).first
      @conversation = cnv.present? ? cnv : Conversation.new(title: uniq, accounts: account_list )
        if @conversation.save

          conversation_message = @conversation.conversation_messages.create(
            user_id: current_user.id, account_id: current_user.account.id, message: msg)  
          conversation_user= conversation_message.conversation_users.create(
                conversation_id: @conversation.id, user_id: current_user.id, account_id: current_user.account.id, archive: false, is_read: true)

          @recipients.each do |recipient|
            if conversation_message.save
              @conversation_user = conversation_message.conversation_users.create(
                conversation_id: @conversation.id,
                user_id: "", archive: false, account_id: (recipient.id) )
            end
          end

          @conversation_messages = @conversation.conversation_messages
          @messages =  current_user.account.conversation_users.inbox.group("conversation_id").count
          @messages = Hash[@messages.sort.reverse]
          @latest_message = Array.new
          if @messages.size > 0
            @messages.each  do |id, v|  
            @latest_message << ConversationMessage.where(
                  "conversation_id = ?",id).order("created_at desc").limit(1).first
            end
          end
           @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
        else
          @error = @conversation.errors.full_messages

        end
      else
        @error = "Please enter message."
      end
    else
      @error = "Please enter recipient."
    end
  end

  def new
  end
  

  def archive
    current_user.account.conversation_users.update_all({archive: true}, ["conversation_id = ?", params[:id]])
    @messages =  current_user.account.conversation_users.archive_msg.group("conversation_id").count
    @messages = Hash[@messages.sort.reverse]
    @latest_message = Array.new
    @messages.each  do |id, v|  
    @latest_message << ConversationMessage.where(
          "conversation_id = ?",id).order("created_at desc").limit(1).first
    end
    @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
  end

  def show
    @current_top_menu = "message"
    current_user.account.conversation_users.update_all({is_read: true}, ["conversation_id = ? and is_read <> ? and is_deleted <> ?", conversation.id, true, true])
    @latest_user = ConversationUser.where("conversation_id = ? and account_id <> ?",conversation.id, current_user.account.id).group("account_id").count
    @conversation_messages = conversation.conversation_messages.order("created_at asc")
    @latest_message = ConversationMessage.where(
          "conversation_id = ?", conversation.id).order("created_at desc").limit(1)
  end

  def message_recent
    @messages =  current_user.account.conversation_users.where("archive = ? and is_deleted = ?", true, false).group("conversation_id").count
    
  end

  def show_archive
    
  end

  def trash
    current_user.account.conversation_users.update_all({is_deleted: true}, ["conversation_id = ?", params[:id]])
    @messages =  current_user.account.conversation_users.inbox.group("conversation_id").count
    @messages = Hash[@messages.sort.reverse]
    @latest_message = Array.new
    if @messages.size > 0
      @messages.each  do |id, v|  
      @latest_message << ConversationMessage.where(
            "conversation_id = ?",id).order("created_at desc").limit(1).first
      end
    end
    @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
  end

  def archive_detail
    @current_top_menu = "message"
    @messages =  current_user.account.conversation_users.archive_msg.group("conversation_id").count
    @messages = Hash[@messages.sort.reverse]
    @latest_user = ConversationUser.where("conversation_id = ? and account_id <> ?", conversation.id, current_user.account.id).first
    @latest_users = ConversationUser.where("conversation_id = ? and account_id <> ?", conversation.id, current_user.account.id).group("account_id").count

    @conversation_messages = conversation.conversation_messages

    current_user.account.conversation_users.update_all({is_read: true}, ["conversation_id = ?", conversation.id])
    @latest_message = Array.new
    @messages.each  do |id, v|  
    @latest_message << ConversationMessage.where(
          "conversation_id = ?",id).order("created_at desc").limit(1).first
    end
    @header_latest_message = ConversationMessage.where(
          "conversation_id = ?", conversation.id).order("created_at desc").limit(1)
    @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
    
  end

  def unread_detail
    @current_top_menu = "message"
    @messages =  current_user.account.conversation_users.where("is_read = ? and is_deleted = ?", false, false).group("conversation_id").count
    @messages = Hash[@messages.sort.reverse]
    @latest_user = ConversationUser.where("conversation_id = ? and account_id <> ?",conversation.id, current_user.account.id).first
    @conversation_messages = conversation.conversation_messages

    current_user.conversation_users.update_all({is_read: true}, ["conversation_id = ?", conversation.id])

    @latest_message = ConversationMessage.where(
          "conversation_id = ?", conversation.id).order("created_at desc").limit(1)
    @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
  end

 def unread_list
  @current_top_menu = "message"
  @messages =  current_user.account.conversation_users.unread_message.group("conversation_id").count
  @messages = Hash[@messages.sort.reverse]
  @latest_message = Array.new
  @messages.each  do |id, v|  
  @latest_message << ConversationMessage.where(
        "conversation_id = ?",id).order("created_at desc").limit(1).first
  end
  @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
 end

 def reply
 
  @reply_message = params[:body].gsub(/\r\n/, "<br>")
  @cu = conversation.conversation_users.select("distinct account_id")
  @conversation_message = conversation.conversation_messages.create(
        user_id: current_user.id, account_id: current_user.account.id, message: params[:body])  
  if params[:attachment_pic].present? && @conversation_message.present?
    params[:attachment_pic].each { |attachment|
      @conversation_message.message_images.create(attachment: attachment)
    }
  end
  if params[:file_attachment].present? && @conversation_message.present?
    params[:file_attachment].each { |attachment|
      @conversation_message.message_images.create(attachment: attachment)
    }
  end
  @cu.each do |user|
  cm = @conversation_message.conversation_users.create(
      conversation_id: @conversation.id, user_id: "", account_id: user.account.id , archive: false, 
      is_read: (user.account.id == current_user.account.id) ? true : false)
    
  end
  @conversation_users = conversation.conversation_users
  @conversation_messages = conversation.conversation_messages 
  @latest_user = ConversationUser.where("conversation_id = ? and account_id <> ?",conversation.id, current_user.account.id).group("account_id").count
  @messages =  current_user.account.conversation_users.inbox.group("conversation_id").count
  @messages = Hash[@messages.sort.reverse]
    @latest_message = Array.new
    if @messages.size > 0
      @messages.each  do |id, v|  
      @latest_message << ConversationMessage.where(
            "conversation_id = ?",id).order("created_at desc").limit(1).first
      end
    end
    @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse

 end

 def reply_archive
   cu = conversation.conversation_users.select("distinct account_id")
   current_user.conversation_users.update_all({archive: false}, ["conversation_id = ?", params[:id]])
   @conversation_message = conversation.conversation_messages.create(
          user_id: current_user.id, account_id: current_user.account.id, message: params[:body]) 

   if params[:attachment_pic].present? && @conversation_message.present?
    params[:attachment_pic].each { |attachment|
      @conversation_message.message_images.create(attachment: attachment)
    }
  end
  if params[:file_attachment].present? && @conversation_message.present?
    params[:file_attachment].each { |attachment|
      @conversation_message.message_images.create(attachment: attachment)
    }
  end 

   cu.each do |user|
     @conversation_message.conversation_users.create(
        conversation_id: @conversation.id, user_id: "", account_id: user.account.id , archive: false,
        is_read: (user.account.id == current_user.account.id) ? true : false)
   end
   @conversation_users = conversation.conversation_users
   @conversation_messages = conversation.conversation_messages
   @messages =  current_user.account.conversation_users.inbox.group("conversation_id").count
   @messages = Hash[@messages.sort.reverse]
   @latest_user = ConversationUser.where("conversation_id = ? and account_id <> ?",conversation.id, current_user.account.id).first
   @latest_message = Array.new
   if @messages.size > 0
    @messages.each  do |id, v|  
    @latest_message << ConversationMessage.where(
          "conversation_id = ?",id).order("created_at desc").limit(1).first
    end
   end
    @latest_messages = @latest_message.sort_by {|msg| msg[:updated_at]}.reverse
 end

 
 def conversation
   @conversation = Conversation.find_by_id(params[:id])
 end

 def search_message
  
  if params[:query].present?
    @conversation_ids = ConversationMessage.text_search(params).map(&:conversation_id).uniq
    @conversation_messages = Array.new
    @conversation_ids.each  do |id|  
      @conversation_messages << ConversationMessage.where(
        "conversation_id = ?",id).order("created_at desc").limit(1).first
    end

  else
    @conversation_messages = []
  end
 end

 def search_within_message
  @conversation_messages = ConversationMessage.where("conversation_id=?", params[:id]).search(params[:query])
  @latest_user = ConversationUser.where("conversation_id = ? and account_id <> ? and is_deleted = ?",conversation.id, current_user.account.id, false).first
 end

 def export_conversation
  @latest_user = ConversationUser.where("conversation_id = ? and account_id <> ?",conversation.id, current_user.account.id).first
  @conversation_messages = conversation.conversation_messages
  @latest_message = ConversationMessage.where(
          "conversation_id = ?", conversation.id).order("created_at desc").limit(1)
  conversation_page = render_to_string "conversation_page.html.erb", :layout => false
  pdf = WickedPdf.new.pdf_from_string(conversation_page.to_s)
  send_data(pdf, :type => "application/pdf",  :filename => "conversation(#{Date.today.strftime("%d-%b-%Y")})")  
  return
 end

 def download_attachment
  attach = MessageImage.find(params[:id])
  if attach.present?
    send_data(attach.attachment_url, :type => "",  :filename => attach.attachment.file.filename)  
  end
  return
 end

 

end
