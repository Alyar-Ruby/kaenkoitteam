# encoding: utf-8
class FeesExchange < ActiveRecord::Base
	validates_presence_of :from_currency_id, :to_currency_id, :provider, :account_type
	belongs_to :kaenko_currency_from, :class_name => "KaenkoCurrency", :foreign_key=>"from_currency_id"
	belongs_to :kaenko_currency_to, :class_name => "KaenkoCurrency", :foreign_key=>"to_currency_id"
end
