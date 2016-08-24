# encoding: utf-8
class PremiumRequestsController < ApplicationController
  def new
    @premium_request = PremiumRequest.new()
  end
  
  def create
    params[:premium_request][:user_id] = current_user.id
    @premium_request = PremiumRequest.new(premium_request_params)
    if @premium_request.save
      flash[:notice] = "Premium Request Sent and is under Approval Proces."
      redirect_to dashboard_overview_path
    else
      render "new"
    end
  end
  
  private

  def premium_request_params
    params.require(:premium_request).permit(:user_id, :request)
  end
  
end
