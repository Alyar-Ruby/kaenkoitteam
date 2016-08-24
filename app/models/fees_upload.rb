# encoding: utf-8
class FeesUpload < ActiveRecord::Base

	has_many :settlement_currencies
	accepts_nested_attributes_for :settlement_currencies
	
	validates_presence_of :payment_option, :account_type, :account

end
