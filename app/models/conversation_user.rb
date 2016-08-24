class ConversationUser < ActiveRecord::Base
	belongs_to :user
	belongs_to :account
	belongs_to :conversation
	belongs_to :conversation_message
	
	before_update :set_time
	
	def set_time
		time = self.updated_at
		self.updated_at = time
	end

	scope :inbox, ->{ where("archive = ? and is_deleted = ?", false, false) }
	scope :archive_msg, ->{ where("archive = ? and is_deleted = ?", true, false) }
	scope :unread_message, ->{ where("archive = ? and is_read = ? and is_deleted = ?", false, false, false) }


	# scope :involving, lambda do |user|
 #    joins(:messages)
 #      .where("conversations.user_id = ?", user.id)
 #      .where("conversations.interlocutor_id = ?", user.id)
 #      .order("messages.created_at DESC")
 #  end

end
