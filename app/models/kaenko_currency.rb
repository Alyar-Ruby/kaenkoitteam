# encoding: utf-8
class KaenkoCurrency < ActiveRecord::Base

  has_many :transactions
  has_many :account_balances
  has_many :earnings
  has_many :payout_currencies
  has_many :settlement_currencies
  has_many :fee_exchanges_from, :class_name=>"FeeExchange", :foreign_key=>"from_currency_id"
  has_many :fee_exchanges_to, :class_name=>"FeeExchange", :foreign_key=>"to_currency_id"
  has_many :orders
  has_many :request_payments
  has_many :accounts
  has_many :banks
  has_many :account_currencies
  has_many :disputes
end
