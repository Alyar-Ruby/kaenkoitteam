class Conversation < ActiveRecord::Base
	has_many :conversation_messages
	has_many :conversation_users
	
end
