# encoding: utf-8
class Earning < ActiveRecord::Base

	belongs_to :kaenko_currency
	
	def self.current_balance
		total = 0 
		self.all.each do |b|
			total = total+ ( ((b.amount* b.fee_earned_percent)/100 + b.fee_earned_value))
		end
		total
	end
end
