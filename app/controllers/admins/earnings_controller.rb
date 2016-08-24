# encoding: utf-8
class Admins::EarningsController < ApplicationController
	skip_before_filter :authenticate_user!
	before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Earnings')"
	respond_to :html, :js, :json
	
	def index
		@earnings = Earning.all
		@last_withdrawal = Earning.last
	end
	
end
