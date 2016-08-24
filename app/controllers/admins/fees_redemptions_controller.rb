# encoding: utf-8
class Admins::FeesRedemptionsController < ApplicationController
	skip_before_filter :authenticate_user!
	before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('FeesRedemptions')"
	respond_to :html, :js, :json
	
	def index
		@feesredemptions = FeesRedemption.all.group_by(&:account)
	end
	
	def new
		@fees_redemption = FeesRedemption.new
		@fees_redemption.payout_currencies.build
	end

	def edit
		@fees_redemption = FeesRedemption.find(params[:id])	
	end

	def create
		@fees_redemption = FeesRedemption.new(fees_redemption_params)
		if @fees_redemption.save
			redirect_to fees_redemptions_path
		else
			render :new
		end
	end

	def update
		@fees_redemption = FeesRedemption.find(params[:id])	
		if @fees_redemption.update_attributes(fees_redemption_params)
			redirect_to fees_redemptions_path
		else
			render :edit
		end
	end

	def destroy
		@fees_redemption = FeesRedemption.find(params[:id])	
		@fees_redemption.destroy
		redirect_to fees_redemptions_path
		
	end

	private

	def fees_redemption_params

		params.require(:fees_redemption).permit(:account, :payment_option, 
			:account_type, :brute_fee_percent, 
			:brute_fee_value, :total_fee_percent, :total_fee_value,
			:our_margin, :limits, :provider, :timing,
			payout_currencies_attributes: [:id, :currency, :fees_redemption_id]) 
			
	end
end
