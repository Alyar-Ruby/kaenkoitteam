# encoding: utf-8
class Admins::UsersController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter :load_user, except: [:index]
  before_filter "active_tab('Users')" 

  def index
    @accounts = Account.includes(:users)
  end
  
  def show
    @sub_users = User.where("account_id = ? and account_admin = ?", @user.account_id, false)
  end

  def active_inactive
    @user.update_column(:active, @user.active ? false : true)
  end

  def user_details
  end

  def edit  
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to users_path
    else
      render :edit
    end
  end

private
  
  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :username, :first_name, :middle_name, 
      :last_name, :gender, :date_of_birth, 
      :nationality, :country, :state, :address, 
      :city, :postal_code, :phone
      )
  end
  
end
