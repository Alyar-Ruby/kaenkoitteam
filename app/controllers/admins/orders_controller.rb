# encoding: utf-8
class Admins::OrdersController < ApplicationController
	skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Orders')"
  
  def index
  	#raise params.inspect
  	from = params[:from_date].to_date.strftime("%Y-%m-%d") if params[:from_date].present?
  	to = params[:to_date].to_date.strftime("%Y-%m-%d") if params[:to_date].present?
  	if from.present? && !to.present?
	  		#raise params[:from_date].to_date.strftime("%Y-%m-%d").inspect
  			@orders = Order.where("Date(created_at) >= ? ", from_date.to_date.strftime("%Y-%m-%d"))
  	elsif !from.present? && to.present?
  			@orders = Order.where("Date(created_at) <= ? ", to.to_date.strftime("%Y-%m-%d"))
  	elsif from.present? && to.present?
  			@orders = Order.where("Date(created_at) BETWEEN ? AND ?  ", 
  				from.to_date.strftime("%Y-%m-%d"), to.to_date.strftime("%Y-%m-%d") )
  	else
  			@orders = Order.order('id asc')
  	end
  end
  
end
