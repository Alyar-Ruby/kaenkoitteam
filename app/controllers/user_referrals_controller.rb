# encoding: utf-8
class UserReferralsController < ApplicationController
	def index
    @current_top_menu = "referrals"
    @referrals = current_user.user_referrals
    @total_earnings = current_user.user_referrals.sum(:current_earnings)
  end
  
	def new
    @current_top_menu = "referrals"
		@user_referral = UserReferral.new
	end
	
	def edit;end
	
	def create
		@user_referral = current_user.user_referrals.create(referral_params)
		if @user_referral.save
			UserMailer.send_referral(current_user, @user_referral.email).deliver
			respond_to do |format|
      	format.json { render json: @user_referral, status: :created }
      	format.js {
      		@referrals = current_user.user_referrals
      	}
      end
		else
			respond_to do |format|
        format.json { render json: @user_referral, status: :created }
        format.js{
        	@user_referral
        }
      end
		end
	end
	
	private
	
	def referral_params
		params.require(:user_referral).permit(:email)
	end
	
	
	
end
