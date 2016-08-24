# encoding: utf-8
class Admins::ReferralsController < ApplicationController
	skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Referrals')"
  
  def index
  	@referrals = Referral.order('id asc')
  end

  def new
  	@referral = Referral.new
  end

  def edit
  	@referral = Referral.find(params[:id])
  end

  def create
		@referral = Referral.new(referral_params)
	  @referral.commission_level = params[:commission_level]
	  if @referral.save
	  	redirect_to referrals_path
	  else
	  	render :new
	  end
  end

  def update
  	@referral = Referral.find(params[:id])
	 	@referral.commission_level = params[:commission_level]
   	if @referral.update_attributes(referral_params)
  		redirect_to referrals_path
  	else
  		render :edit
   	end
  end

  def destroy
    @referral = Referral.find(params[:id])
    @referral.destroy
    redirect_to referrals_path    
  end

  private

  def referral_params
  	params.require(:referral).permit(:account_type, :commission_level)
  end
  
end
