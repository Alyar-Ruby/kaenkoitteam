# encoding: utf-8
class AccountsController < ApplicationController

  skip_before_filter :check_setup, :only => [:account_setup, :update_security]
  respond_to :js, :json,:html

  def index
#
    @current_tab = "settings"
    @account = current_user.account  
    currency_ids = @account.account_balances.collect{|c| c.kaenko_currency_id}
    @account_currencies =  (currency_ids.size > 0) ? KaenkoCurrency.where("id not in (?)", currency_ids) : KaenkoCurrency.all
    @activate_tab = params[:activate]

    
  end

  def account_setup
    
  end
  
  def update_currency
    @account = current_user.account
    @account_currency = @account.account_balances.where("kaenko_currency_id = ?", params[:account][:kaenko_currency_id])
    primary =  @account.account_balances.where("is_primary=?", true)
    if primary.size > 0
      primary.first.update_attributes(is_primary: false)
    end
    if @account_currency.size > 0
      @account_currency.first.update_attributes(is_primary: true)
    else
      @account.account_balances.create(kaenko_currency_id: params[:account][:kaenko_currency_id], is_primary: true, balance: 0.0)
    end
    @account.update_attributes(:kaenko_currency_id=>params[:account][:kaenko_currency_id])
    respond_to do |format|
		  format.html {
		  	redirect_to account_setting_path
		  }
		  format.js {
		  	@account
		  }
    end
  end

  def update_security
    if current_user.update_attributes(user_params)
      current_user.account.update_column(:time_zone, params[:time_zone])
      redirect_to account_setting_path  
    else
      render :account_setup
    end

  end
  
  def update
    @account = current_user.account
    @account.update(:search_by => params[:search])
    respond_to do |format|
		  format.html {
		  	redirect_to account_setting_path
    		return
		  }
		  format.js {
		  	render :js => @account
		  }
    end
=begin    
    old_pin = @account.pin
    #raise params.inspect
    if @account.update(account_params)
      flash[:notice] = "Account Settings Updated."
      
      if old_pin.present?
        redirect_to account_setting_path
      else
        redirect_to verify_path
      end
    else
      render "edit"
    end    
=end
  end

  def edit_address
  end

  def edit_status
  end
  
  def verify
    @user = current_user
  end
  
  def verified
    @account = current_user.account
    @account.account_status_document = params[:account_status_document]
    @account.verified = true
    if @account.save
     render :text => "Your Account status is now Verified."
    else
      head :no_content, :status => :bad_request
   end

  end

  def edit_account_document

  end

  def upload_account_document
    @account = current_user.account
    @account.account_document = params[:account_document]
    if @account.save
      render :text => "Your Account status is now Verified."
    else
      head :no_content, :status => :bad_request
    end
  end

  def edit_account_id_document
  end

  def upload_account_id_document
    @account = current_user.account
    @account.account_id_document = params[:account_id_document]
    if @account.save
      render :text => "Your Account status is now Verified."
    else
      head :no_content, :status => :bad_request
    end
  end

  def update_time_zone
    @account = current_user.account
    @account.update_attributes(:time_zone=>params[:account][:time_zone])
    respond_to do |format|
      format.html {
        redirect_to account_setting_path
      }
      format.js {
        @account
      }
    end
  end
  def update_popup_time_zone
    @account = current_user.account
    if params[:active] == "yes"
      @account.update_attributes(:time_zone => browser_timezone )
      respond_to do |format|
        format.js {
          @account
        }
      end
    else
      session[:time_zone] = "cancel"
    end
  end

  def privacy_settings

  end

  def email_notifications

  end

  
  private

  def user_params
    params.require(:user).permit(:user_security_question_id, :secret_question_answer, :security_pin )
  end
  def account_params
    params.require(:account).permit(:pin, :pin_confirmation, 
                                    :user_security_question_id,
                                    :security_question_answer, 
                                    :search_by, :kaenko_currency_id
                                    )
  end
  
end
