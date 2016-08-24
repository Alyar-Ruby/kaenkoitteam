# encoding: utf-8
class FeesRedemption < ActiveRecord::Base

	has_many :payout_currencies
	accepts_nested_attributes_for :payout_currencies
	validates_presence_of :payment_option, :account_type, :account
	
end
