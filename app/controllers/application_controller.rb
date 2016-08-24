# encoding: utf-8
class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  before_filter :check_setup
  before_filter :kaenko_countries
  helper_method :kaenko_countries
  helper_method :browser_timezone
  helper_method :connection_list
  helper_method :account_staffs

  around_filter :user_time_zone, if: :current_user

  
  
  def kaenko_countries()
    remove_country = ["US", "SY", "IQ", "IR", "AF", "KR", "KP", "SO", "ET", "ER", "RW", "TD", "GY"]
    @kaenko_countries = Array.new
    Country.all.each do |c,i|
      if !remove_country.include?i
        @kaenko_countries << [c,i]
      end
    end
  end
  
  def generate_account_number()
    chars = ("0".."9").to_a
    newpass = ""
    1.upto(6) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
  def active_tab(tab)
    @active_tab = tab
  end
  
  #after sign in path
  def after_sign_in_path_for(resource)
    if user_signed_in?
      if resource.pin.present?
        resource.update_column(:pin, nil)
        session[:return_to] || account_setting_path
      else
        session[:return_to] || stored_location_for(resource) || root_url
      end
    else    
      super
    end
  end
  
  def after_sign_out_path_for(resource)
    if resource.to_s == "admin"
      session[:previous_url] || {:controller=>"admins/homes", :action=>"index"}
    else
      session[:previous_url] || root_path
    end
  end  
  helper_method :converted_currency
  def converted_currency(amount, from_currency, to_currency)
  	Money.default_bank = Money::Bank::GoogleCurrency.new
    Money.new(amount, from_currency).exchange_to(to_currency).fractional
  end

  def check_setup
    if current_user && !current_user.security_pin.present?
      redirect_to account_setup_path
      return
    end
  end

  def browser_timezone
    cookies["browser.timezone"]
  end

  def connection_list
    @user_connections = Connection.user_all_connection(current_user.account).limit(10)
  end

  def account_staffs
    current_user.account.users.where("id <> ?", current_user.id)
  end

  private

  def user_time_zone(&block)
    if current_user.account.time_zone.present?
      Time.use_zone(current_user.account.time_zone, &block) 
    else
      Time.use_zone("UTC", &block) 
    end
  end


  
end
