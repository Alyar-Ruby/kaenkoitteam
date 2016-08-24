class UserCapability < ActiveRecord::Base
	belongs_to  :user
	belongs_to :capability
end
