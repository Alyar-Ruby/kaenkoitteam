# encoding: utf-8
class AccountBalance < ActiveRecord::Base
  belongs_to :account
  belongs_to :kaenko_currency
  validates :kaenko_currency_id, :presence => true, :uniqueness => {:scope => :account_id}
end
