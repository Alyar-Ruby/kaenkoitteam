class Bank < ActiveRecord::Base
	belongs_to :user
	belongs_to :kaenko_currency
  
  validates :name, :presence => { :message => "Bank Name can't be blank" }
  validates :kaenko_currency_id, :presence => { :message => "Currency can't be blank" }
end
