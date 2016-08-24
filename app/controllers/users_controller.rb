    class UsersController < ApplicationController
    respond_to :html, :json, :js

    skip_before_filter :authenticate_user! , :only => [:edit_subuser, :update_subuser]
    before_filter :find_user, :except => [:new, :create, :update_image]

    def social
      @current_top_menu = "social"
      @account = Account.find(params[:id])
      if @account.present?
        c1 = Connection.where(from_account_id: current_user.account.id, to_account_id: @account.id)
        c2 = Connection.where(to_account_id: current_user.account.id, from_account_id: @account.id)
       @connection = Array.new
       if c1.present? && !c2.present?
        @connection  = c1
       else
        @connection  = c2
       end
        @user_connections = Connection.user_all_connection(@account)
        #raise @user_connections.inspect
        @posts = Post.where("to_account_id = ?", @account.id).order("created_at desc").includes(:comments)
      else
        redirect_to dashboard_overview_path
      end
    end

    def new
        @user = User.new
    end

    def edit 

    end

    def update
      @error = ""
      if @user.update_attributes(user_params)
          @user.roles.destroy_all
          UserCapability.where("user_id =?", @user.id).destroy_all
          if params[:role_ids].present?
              params[:role_ids].each do |role|
                  @role = Role.find(role)
                  @user.roles << @role if @role
              end
          end
          if params[:cap_ids].present?
              params[:cap_ids].each do |cap|
                  UserCapability.create(user_id: @user.id, capability_id: cap.to_i, daily_limit: params["daily_limit"+cap])
              end
          end
      else
          @error = @user.errors.full_messages.join("")
      end
        
    end
    
    def create
      require 'securerandom'
      password = SecureRandom.hex(8)
      @user = User.new(user_params)
      @user.password = password
      @user.account_id = current_user.id
      @user.account_admin = false
      @user.subuser = true
      @user.confirmed_at = DateTime.now
      #@user.skip_confirmation_notification!
      if @user.save
          UserMailer.send_subuser_activation(@user).deliver
          if params[:role_ids].present?
              params[:role_ids].each do |role|
                  @role = Role.find(role)
                  @user.roles << @role if @role
              end
          end
          if params[:cap_ids].present?
              params[:cap_ids].each do |cap|
                  UserCapability.create(user_id: @user.id, capability_id: cap.to_i, daily_limit: params["daily_limit"+cap])
              end
          end
      end
      respond_with(@user) 
    end
    
    def advance_search
    end

    def update_image
      user = current_user
      user.image = params[:user_pic]
      if user.save
          render :json=>{:circle=>user.image_url(:circle), :profile=>user.image_url(:profile)}, layout: false
      else
          render :json =>{ :errors => user.errors.full_messages.join("") }, :status => 422, :layout => false
      end
    end

    def update_online_status
      if current_user.online_status == true 
          current_user.update_column(:online_status, false)
      else
          current_user.update_column(:online_status, true)
      end
    end

    def edit_secret
      @account = current_user.account
    end

    def update_secret
      if @user.update_attributes(user_params)
          sign_in(@user, :bypass => true)
      end
    end

    def update_secret_ques
      @user.update_attributes(user_params)
    end

    def update_secret_ans
      @user.update_attributes(user_params)
    end

    def update_security_pin
      @user.update_attributes(user_params)
    end

    def update_secret_pin
      @user.update_attributes(user_params)
    end

    def update_pay_out_over
      @user.update_attributes(user_params)
    end

    def check_pin
        @allowed = (user_params[:security_pin] == @user.security_pin) ? true : false
    end


    def edit_address
      @user_action = params[:user_action]
      if @user_action == "_verify"
          @user.country = nil
          @user.state = nil
          @user.address = nil
          @user.city = nil
      end
    end


    def update_address
      @user = User.find(params[:id])
      @errors = Array.new
      if @user.update_attributes(user_params)
          if params[:user_action] == "_verify"
              @user.update_column(:address_verified, false)
          end
          @user
      else
           @errors = @user.errors.full_messages.join(",")
      end
    end

    def edit_contact
    end

    def update_contact
      @errors = Array.new
      if @user.update_attributes(user_params)
        @user
      else
        @errors = @user.errors.full_messages.join(",")
      end
    end

    def edit_personal_address
        @user = current_user
    end

    def update_personal_address
        @user = current_user
        @errors = Array.new
        if @user.update_attributes(user_params)
            @user
        else
             @errors = @user.errors.full_messages.join(",")
    end
    end

    def edit_address_document
    end

    def verify_address_document
        current_user.address_document = params[:address_document]
        if current_user.save
            current_user.update_column(:address_verified, true)
            render :text => "Your Registered Address status is now Verified."
        else
      head :no_content, :status => :bad_request
        end
    end

    def destroy
        @account = @user.account
        @user.destroy
    end

    def suspend_account
        @user.update_column(:suspend, true)
        @account = @user.account
    end

    def update_language
        current_user.update_column(:language, params[:user][:language])
    end

    def autocomplete_user
    @accounts = Account.search(params[:searchword])
    render :layout => false
  end

  def search_connection
    @connections = []
    @all_connections = Connection.user_all_connection(current_user.account)
    @all_connections.each do |con|
      @connections << ((con.to_account.id == current_user.account.id ) ? con.from_account.id : con.to_account.id)
    end
    @accounts = Account.search(params[:search_word])
    @search_list = (@accounts.map(&:id) & @connections)
    #raise @search_list.inspect
    @search_result = Account.where(id: @search_list)
    render :layout => false
    #raise (@all_connections & @accounts.map(&:id)).inspect
  end

  def edit_subuser
    @user.pin = nil
    return redirect_to new_user_session_path if @user.subuser == false
    render :layout=> "blank" 
  end

  def update_subuser
    if @user.pin != params[:user][:pin]
        @user.errors.add(:pin, "Please enter correct pin")
        render :edit_subuser, :layout => "blank"
        return
    end
    if !simple_captcha_valid?
        @error = 1
        @captcha_error = "In-valid Captcha"
        render :edit_subuser, :layout => "blank"
            return
    end
    params[:user][:subuser] = false
    if @user.update_attributes(user_params)
        @user.update_column(:confirmed_at, nil) 
        if @user && @user.confirmed_at.nil?
            token = Devise.token_generator.generate(@user.class, :confirmation_token)
            @user.confirmed_at = nil
            @user.confirmation_sent_at = DateTime.now
            @user.confirmation_token = token[1]
            @user.save(:validate => false)
            UserMailer.subuser_confirmation(@user, token[0]).deliver
        end
        redirect_to new_user_session_path, notice: "An confimation link sent to your account"
    else
        render :edit_subuser, :layout => "blank"
        return
    end
    
  end

  def edit_security_pin
  end

  def update_security_pin
    @user.update_attributes(user_params)
  end

  def update_email
    @error = ""
    @user = User.find(params[:id])
    if !@user.update_attributes(user_params)
        @error = @user.errors.full_messages.join("")
    end
  end

  def update_about_me
    @error = ""
    @user = User.find(params[:id])
    if !@user.update_attributes(user_params)
        @error = @user.errors.full_messages.join("")
    end
  end

  def update_country
    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end

  def update_city_postal

    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end

  def update_user_dob
    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end

  def update_phone
    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end
  def update_first_name
    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end
  def update_last_name
    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end
  def update_job_title
    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end

  def update_user_gender
    @error = ""
    if !@user.update_attributes(user_params)
      @error = @user.errors.full_messages
    end

  end

  def edit_permission

  end

  def update_permission
    @user.roles.destroy_all
    UserCapability.where("user_id =?", @user.id).destroy_all
    if params[:role_ids].present?
        params[:role_ids].each do |role|
            @role = Role.find(role)
            @user.roles << @role if @role
        end
    end
    if params[:cap_ids].present?
        params[:cap_ids].each do |cap|
            UserCapability.create(user_id: @user.id, capability_id: cap.to_i,
             daily_limit: params["daily_limit"+cap])
        end
    end
  end

  def upload_subuser_image
    @user.image = params[:user_image]
    if @user.save
      render :json=>{:circle=>@user.image_url(:circle), :profile=>@user.image_url(:profile)}, layout: false
    else
      render :json =>{ :errors => @user.errors.full_messages.join("") }, :status => 422, :layout => false
    end
  end

  def social_message
    @account = Account.find(params[:id])
    @conversation = Conversation.new
  end

  def create_social_message
    @account = Account.find(params[:id])
    msg = params[:conversation][:title]
    @recipients = Array.new
    @recipients << @account.id
    account_list = (@recipients << current_user.account.id).sort!.join("")
    cnv = Conversation.where("accounts = ?", account_list).first
    uniq = Digest::MD5.hexdigest(Time.now.to_f.to_s+"_s_"+current_user.id.to_s)
    @conversation = cnv.present? ? cnv : Conversation.new(title:uniq , accounts: account_list )
    if @conversation.save
      conversation_message = @conversation.conversation_messages.create(
            user_id: current_user.id, account_id: current_user.account.id, message: msg)  
          conversation_user= conversation_message.conversation_users.create(
                conversation_id: @conversation.id, user_id: current_user.id, account_id: current_user.account.id, archive: false, is_read: true)
      if conversation_message.save
            @conversation_user = conversation_message.conversation_users.create(
              conversation_id: @conversation.id,
              user_id: "", archive: false, account_id: (@account.id) )
      end
    end
  end

private

    def user_params
        params.require(:user).permit(:username, :email, :first_name, :middle_name, 
                                 :last_name, :gender, :date_of_birth,
                                 :nationality, :country, :address,
                                 :city,  :phone, :job_title, :state, :pin, :image, :password, 
                                 :password_confirmation, :subuser, :user_security_question_id, 
                                 :secret_question_answer, :security_pin, :postal_code, :pay_out_over, :about_me
                                )
    end

    def find_user
        @user = User.find_by_id(params[:id])
    end
    
end

