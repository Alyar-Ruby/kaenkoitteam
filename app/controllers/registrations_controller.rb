# encoding: utf-8
class RegistrationsController < Devise::RegistrationsController
  layout "blank"

  def member
    build_resource({})
  end
  
  def create_member
    check_invite = Invite.find_by_email(params[:user][:email])
    
    @error = 0
    @invite_error  = ""
    if !check_invite.present?
      @error = 1
      @invite_error = "Email does not invited for account member."
    end
    
    if @error == 0
      params[:user][:account_id] = check_invite.account_id
      params[:user][:account_admin] = false
      build_resource(sign_up_params)
      
      @captcha_error  = ""
      
      if !resource.valid?
        @error = 1
      end
      
      if !simple_captcha_valid?
        @error = 1
        @captcha_error = "In-valid Captcha"
      end
    else
      build_resource(sign_up_params)
    end
    
    if @error == 0 and resource.save()      
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      render "member"
    end
  end
  
  def new
    build_resource({})
    #respond_with self.resource
    if params[:user].present? and params[:user][:roleable_type] == "premium"
      resource.build_premium_request
    end
    if params[:user].present? and params[:user][:roleable_type].present?
      render params[:user][:roleable_type] 
    end
  end
  
  def create
    if params[:roleable_type] != "member"
      check_invite = Invite.find_by_email(params[:user][:email])
      
      if check_invite.present?
        flash[:alert] = "You are invited to manage the accounts of 
                          #{check_invite.account.roleable.organization_name} 
                          Use this form to accept invite"
        redirect_to  member_sign_up_path 
        return
      end
    end
    
    if params[:roleable_type] == "premium"
      account_roleable_type = "Business"
      account_approved = false
      account_premium = true
      account_active = false
      params[:user][:active] = false
    else
      account_roleable_type = params[:roleable_type].capitalize
      account_approved = true
      account_premium = false
      account_active = true
      params[:user][:active] = true
    end

    build_resource(sign_up_params)
    if account_roleable_type == "Business"
      if account_premium == false
        if KaenkoSetting.first.present?
          params[:user][:roleable][:commission] = KaenkoSetting.first.business_commission 
        end
      end
      @business = Business.new(business_params)
    end
    
    @error = 0
    @captcha_error  = ""
    if account_roleable_type == "Business" 
      if !@business.valid?
        @error = 1
      end
    end
    if !resource.valid?
      @error = 1
    end
    if !simple_captcha_valid?
      @error = 1
      @captcha_error = "In-valid Captcha"
    end
    
    if @error == 0 and resource.save()
      account_number = generate_account_number()
      e_account_number = 0
      check_account_number = Account.find_by_account_number(account_number)
      
      if !check_account_number.blank?
        e_account_number = check_account_number.account_number
      end
      while e_account_number != 0
        account_number = generate_account_number()
        e_account_number = 0
        check_account_number = User.find_by_account_number(account_number)
        if !check_account_number.blank?
          e_account_number = check_account_number.account_number
        end
      end	
            
      if account_roleable_type == "Business"
        @business = Business.new(business_params)
        if @business.save
          account_roleable_id = @business.id
        end
      end
      platform_limit = (account_roleable_type == "Business") ? "9999" : "2500"
      @account = Account.new(:account_number => account_number, 
                             :roleable_type => account_roleable_type, 
                             :roleable_id => account_roleable_id, 
                             :approved => account_approved,
                             :kaenko_currency_id => 1,
                             :premium => account_premium, :active => account_active,
                             :platform_limit => platform_limit ,
                             :time_zone => browser_timezone
                            )
      @account.save
      
      resource.account_id = @account.id
      resource.save
      referral = UserReferral.where("email = ?", resource.email)
      referral.size > 0 ? referral.first.update_attributes(status: "Inactive") : ""
      resource.pending_transactions
      
      if account_premium == true
        resource.premium_request.account_id = @account.id
        resource.premium_request.save
      end
      
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      if (@business.present? and @business.errors.present? and @business.errors.messages.present?)
        @business_errors = @business.errors.messages
      end
      clean_up_passwords resource     
      if params[:user][:premium] == true
        render "premium"
      else
        render account_roleable_type.downcase
      end
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
   
      if !params[:user][:password].present?
        if resource.update_without_password(account_update_params)
          sign_in resource_name, resource, :bypass => true
          flash[:notice] = "Your account details have been updated. Thank you."
          redirect_to edit_user_registration_url()
        else
          clean_up_passwords resource
          respond_with resource
        end
      else
        if resource.update_with_password(account_update_params)
          #raise "t".inspect
          sign_in resource_name, resource, :bypass => true
          flash[:alert] = "Password updated."
          respond_to do |format|
             format.html {
              respond_with resource, :location =>after_update_path_for(resource)
             }
             format.js {
              @user_updated = true
             }
          end
          #respond_with resource, :location => change_password_url()
      else
        clean_up_passwords resource
       # raise resource.errors.inspect
        respond_with(resource.errors) do |format|
          format.html { render :action => :change_password }
           format.js {
            @user_updated = resource.errors.full_messages.join("")
           }
        end
      end
      
      end
      
      #respond_with resource, :location => after_update_path_for(resource)
    
  end
  
  def change_password    
    @user = current_user
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def build_resource(hash=nil)
    hash ||= resource_params || {}
    self.resource = resource_class.new_with_session(hash, session)
  end 
  
  def profile
    @user = User.find_by_username(params[:username])
    if @user.account_id != current_user.account_id or !current_user.account_admin
      flash[:alert] = "You are not authorized to view the profile of this user"
      redirect_to dashboard_url
    end
    render :layout=>"application"
  end
  
  private
   
  def account_update_params
    params.require(:user).permit(:username, :first_name, :middle_name, 
                                 :last_name, :gender, :date_of_birth,
                                 :nationality, :country, :state, :address, 
                                 :city, :postal_code, :phone, :language, 
                                 :representative_position, :current_password, 
                                 :password, :password_confirmation
                                )
  end 
  
  def business_params
    params[:user].require(:roleable).permit(:country_of_incorporation, :organization_name,
                                            :organization_url, :legal_form, :registration_number, 
                                            :date_of_incorporation, :industry, :country, :state,
                                            :address, :city, :postal_code, :commission
                                          )
  end  
  
  def sign_up_params
    params.require(:user).permit(:username, :first_name, :middle_name, 
                                 :last_name, :gender, :date_of_birth, 
                                 :nationality, :country, :state, 
                                 :address, :city, :postal_code, 
                                 :phone, :language, :account_admin,
                                 :representative_position, :password, 
                                 :password_confirmation, :email, 
                                 :email_confirmation, :account_id, 
                                 :active, premium_request_attributes: [:id, :request]
                                )
  end
end

