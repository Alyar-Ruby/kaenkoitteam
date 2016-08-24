class ConversationMessage < ActiveRecord::Base
	belongs_to :user
  belongs_to :account
	belongs_to :conversation
	has_many :conversation_users
	has_many :message_images

	include PgSearch
  pg_search_scope :search, against: [:message]
   

  def self.text_search(params)
    search(params[:query])
  end

  def created_at
    super.in_time_zone if super
  end

  def updated_at
    super.in_time_zone if super
  end

end
