# encoding: utf-8
class InvitesController < ApplicationController
  
  def index
    @invites = current_user.account.invites
  end
  
  def new
    @invite = Invite.new()
  end
  
  def create
    check_user = User.where("email = ?",params[:invite][:email])
    if check_user.present?
      respond_to do |format|
        errors = Hash.new()
        errors[:email] = "email has already registered for another account"
        format.json { render :status => :unprocessable_entity, :json => {:errors => errors} }
      end
    else
      params[:invite][:account_id] = current_user.account_id
      @invite = Invite.new(invite_params)        
      if @invite.save
        
        UserMailer.send_invite(current_user, params[:invite][:email]).deliver
        
        respond_to do |format|
          format.json { render json: @invite, status: :created }
        end
      else
        respond_to do |format|
          format.json { 
            render :status => :unprocessable_entity, 
            :json => { :errors => @invite.errors } 
          }
        end
      end
    end
  end
  
  private

  def invite_params
    params.require(:invite).permit(:account_id, :email)
  end
end
