# encoding: utf-8
class Admins::PremiumRequestsController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('PremiumRequests')"
  
  def index
    @premium_requests = PremiumRequest.all
  end
  
  def show
    @premium_request = PremiumRequest.where("id = ?",params[:id]).first
  end
  
  def update
    if premium_request_params[:status] == "approved"
      @premium_request = PremiumRequest.where("id = ?",params[:id]).first
      if @premium_request.account.roleable_type == "Business" and 
        (!params[:premium_request][:business].present? or
         !params[:premium_request][:business][:commission].present?)
        respond_to do |format|
          errors = Hash.new()
          errors[:commission] = "cannot be blank"
          format.json { render :status => :unprocessable_entity, :json => {:errors => errors} }
        end      
      else
        if @premium_request.update_attributes(premium_request_params)
          @premium_request.account.update_attributes(:premium => true, 
                                                     :approved=>true, :active=>true
                                                    )
          @premium_request.user.update_attributes(:active=>true)
          
          if params[:premium_request][:business].present? and 
            params[:premium_request][:business][:commission].present?
            @premium_request.account.roleable.update_attributes(
                              :commission=>params[:premium_request][:business][:commission]
                              )
          end
          AdminMailer.send_premium_request_response(@premium_request.user).deliver
          respond_to do |format|
            format.json { render json: @premium_request, status: :created }
          end
        else
          respond_to do |format|
            format.json { render :status => :unprocessable_entity, 
              :json => { :errors => @premium_request.errors } 
            }
          end
        end
      end
    elsif premium_request_params[:status] == "rejected"
      @premium_request = PremiumRequest.where("id = ?",params[:id]).first
      if @premium_request.update_attributes(premium_request_params)
        @premium_request.account.update_attributes(:premium => false)
      
        AdminMailer.send_premium_request_response(@premium_request.user).deliver
        
        respond_to do |format|
          format.json { render json: @premium_request, status: :created }
        end
      else
        respond_to do |format|
          format.json { render :status => :unprocessable_entity, 
            :json => { :errors => @premium_request.errors } 
          }
        end
      end
    end
  end
  
  def approve
    @premium_request = PremiumRequest.where("id = ?",params[:id]).first
    @premium_request.status = "approved"
  end
  
  def reject
    @premium_request = PremiumRequest.where("id = ?",params[:id]).first
    @premium_request.status = "rejected"
  end
  
  private

  def premium_request_params
    params.require(:premium_request).permit(:status, :comments)
  end
end
