class Invoice < ActiveRecord::Base
	has_many :invoice_items
	belongs_to :kaenko_currency
	belongs_to :user
	accepts_nested_attributes_for :invoice_items, allow_destroy: true

	after_create :send_pay_request


	def send_pay_request
		UserMailer.send_invoice_request(self).deliver
	end


end
