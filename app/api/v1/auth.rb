module API
  module V1
    class Auth < Grape::API
      include API::V1::Defaults
      resources :auth do
				desc "Creates and returns access_token if valid login"
				params do
					requires :client_id, type: String, desc: "client id"
					requires :client_secret, type: String, desc: "client secret"
				end
				post :login do
					if params[:client_id].present? && params[:client_secret].present?
						api_client = ApiClient.where(client_id: params[:client_id],
												 	client_secret: params[:client_secret])
						if api_client.size > 0
							key = ApiKey.create(api_client_id: api_client.first.id)
							{token: key.access_token}
						else
							error!('Unauthorized.', 401)
						end
					else
						error!('Unauthorized.', 401)
					end
				end
				desc "Returns pong if logged in correctly"
				params do
					requires :token, type: String, desc: "Access token."
				end
			end  
    end
  end
end
