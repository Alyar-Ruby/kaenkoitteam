# encoding: utf-8
class SettlementCurrency < ActiveRecord::Base
	belongs_to :fees_upload
	belongs_to :kaenko_currency
end
