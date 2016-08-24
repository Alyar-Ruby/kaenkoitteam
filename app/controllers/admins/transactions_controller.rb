# encoding: utf-8
class Admins::TransactionsController < ApplicationController
	skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Transactions')"
  
  def index
  	if params[:from].present?
  		@transactions = Transaction.where("transaction_from = ?", params[:from]).order('created_at desc')
  	else
  		@transactions = Transaction.order('created_at desc')
  	end
  end
end
