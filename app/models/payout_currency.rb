# encoding: utf-8
class PayoutCurrency < ActiveRecord::Base
	belongs_to :fees_redemption
	belongs_to :kaenko_currency
end
