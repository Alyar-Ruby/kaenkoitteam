# encoding: utf-8
class Admins::FeesUploadsController < ApplicationController
	skip_before_filter :authenticate_user!
	before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Feesfromtos')"
	respond_to :html, :js, :json
	
	def index
		@feesuploads = FeesUpload.all.group_by(&:account)
	end
	
	def new
		@fees_upload = FeesUpload.new
		@fees_upload.settlement_currencies.build
	end

	def edit
		@fees_upload = FeesUpload.find(params[:id])	
	end

	def create
		@fees_upload = FeesUpload.new(fees_upload_params)
		if @fees_upload.save
			redirect_to fees_uploads_path
		else
			render :new
		end
	end

	def update
		@fees_upload = FeesUpload.find(params[:id])	
		if @fees_upload.update_attributes(fees_upload_params)
			redirect_to fees_uploads_path
		else
			render :edit
		end
	end

	def destroy
		@fees_upload = FeesUpload.find(params[:id])	
		@fees_upload.destroy
		redirect_to fees_uploads_path
	end

	private

	def fees_upload_params

		params.require(:fees_upload).permit(:account, :payment_option, 
			:account_type, :brute_fee_percent, 
			:brute_fee_value, :total_fee_percent, :total_fee_value,
			:our_margin, :limits, :provider, :refund,
			settlement_currencies_attributes: [:id, :currency, :fees_upload_id]) 
			
	end
end
