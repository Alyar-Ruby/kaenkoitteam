# encoding: utf-8
class Admins::FeesExchangesController < ApplicationController
	skip_before_filter :authenticate_user!
	before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('FeesExchanges')"
	respond_to :html, :js, :json
	
	def index
		@feesexchanges = FeesExchange.all
	end
	
	def new
		@fees_exchange = FeesExchange.new
	end
	
	def create
		@fees_upload = FeesExchange.new(fees_exchange_params)
		if @fees_upload.save
			redirect_to fees_exchanges_path
		else
			render :new
		end
	end
	
	def edit
		@fees_exchange = FeesExchange.find(params[:id])
	end
	
	def update
		@fees_exchange = FeesExchange.find(params[:id])
		if @fees_exchange.update_attributes(fees_exchange_params)
			redirect_to fees_exchanges_path
		else
			render :edit
		end
	end

	def destroy
		@fees_exchange = FeesExchange.find(params[:id])
		@fees_exchange.destroy
		redirect_to fees_exchanges_path
	end
	
	private
	
	def fees_exchange_params
			params.require(:fees_exchange).permit(:from_currency, :to_currency, 
			:fee_percent, :fee_value, :our_fee, :fx_fee, :provider, :limit_pd, :exchange_group, 
			:account_type) 
	end
end
