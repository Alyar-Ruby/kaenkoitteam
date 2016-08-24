class RequestPayment < ActiveRecord::Base
	belongs_to :user
	belongs_to :kaenko_currency

	after_create :send_request

	private

	def send_request
		UserMailer.send_request_payment(self).deliver
	end

	
end
