# encoding: utf-8
class UserSecurityQuestion < ActiveRecord::Base
	has_many :users
end
