class Admins::ApiClientsController < ApplicationController
	skip_before_filter :authenticate_user!
	before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Apiclients')"
	respond_to :html, :js, :json
	
	def index
		@api_clients = ApiClient.all
	end
	
	def new
		@api_client = ApiClient.new
	end
	
	def create
		@api_client = ApiClient.new(ApiClient.api_client_hash(params[:api_client][:email]))
		if @api_client.save
			redirect_to api_clients_path
		else
			render :new
		end
	end
	
	
end
