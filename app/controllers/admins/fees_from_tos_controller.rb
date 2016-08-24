# encoding: utf-8
class Admins::FeesFromTosController < ApplicationController
	skip_before_filter :authenticate_user!
	before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('FeesFromTos')"
	respond_to :html, :js, :json
	
	def index
		@feesfromtos = FeesFromTo.all
	end
	
	def new
		@fees_from_to = FeesFromTo.new
	end

	def create
    @fees_from_to = FeesFromTo.new(fees_from_to_params)
    if @fees_from_to.save
      flash[:notice] = "Fees Added Successfully"
      redirect_to fees_from_tos_path
    else
      render "new"
    end
	end
	
	def edit
		@fees_from_to = FeesFromTo.where("id = ?",params[:id]).first
	end

	def update
		@fees_from_to = FeesFromTo.where("id = ?",params[:id]).first
    if @fees_from_to.update_attributes(fees_from_to_params)
      flash[:notice] = "Fees Updated Successfully"
      redirect_to fees_from_tos_path
    else
      render "edit"
    end
	end
	
	def destroy
		@fees_from_to = FeesFromTo.where("id = ?",params[:id]).first
    @fees_from_to.destroy
    redirect_to fees_from_tos_path
	end
  
  private

  def fees_from_to_params
    params.require(:fees_from_to).permit(:from_account, :to_account, :mode, 
    																			:fee_percent, :fee_value
    																		)
  end
end
