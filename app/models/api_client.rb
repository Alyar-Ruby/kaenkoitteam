class ApiClient < ActiveRecord::Base

#  =================
#  =  Validations  =
#  =================

validates :email, :client_id, :client_secret, presence: true
validates :email, :format => { :with => /\A([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)\Z/i }


	def self.api_client_hash(email)
		api_client = 
		{
			email: email,
			client_id: Digest::MD5.hexdigest(email),
			client_secret: Digest::MD5.hexdigest(Time.now.to_f.to_s+"_c_"+"0a53h9yl1")
		}
		api_client
	end
end
