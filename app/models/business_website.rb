class BusinessWebsite < ActiveRecord::Base
	belongs_to :business
	validates :website_url , presence: true
	validates_format_of :website_url , :with => /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?/ix

	attr_accessor :website_protocol

	def website_protocol

	end
end
