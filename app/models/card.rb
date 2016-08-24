class Card < ActiveRecord::Base
	belongs_to :user
  attr_reader :expiry_month, :expiry_year
  attr_writer :expiry_month, :expiry_year
end
