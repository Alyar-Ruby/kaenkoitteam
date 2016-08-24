class MessageImage < ActiveRecord::Base
	mount_uploader :attachment, MessageImageUploader
	belongs_to :conversation_message
end
