# encoding: utf-8
class PublicController < ApplicationController
	before_filter :authenticate_user!
	
  def index
  	# @msgs = UserMessage.find_all_by_user_id(current_user.id)
  	#@msgs = UserMessage.find(:all)
  end
  
  def new_message
  #raise params.inspect
  # Check if the message is private
  #raise params[:message].inspect
  #if params[:message] == "anshul" #params[:message].match(/@(.+) (.+)/)
  #raise "rt".inspect
  
    # It is private, send it to the recipient's private channel
    @channel = "/messages/private/"+params[:to]
    @message = { :username => current_user.username, :msg => params[:message] }
  #else
    # It's public, so send it to the public channel
   
    #@channel = "/messages/public"
    #@message = { :username => session[:username], :msg => params[:message] }
  #end
 
		respond_to do |f|
		  f.js
		end
	end
end
