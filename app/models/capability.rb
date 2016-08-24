class Capability < ActiveRecord::Base
	has_many :user_capabilities
	has_many :users, through: :user_capabilities
end
