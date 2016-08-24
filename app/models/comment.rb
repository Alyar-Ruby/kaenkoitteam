class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :account
	belongs_to :post
	validates :title, :presence => true

	def created_at
    super.in_time_zone if super
  end

  def updated_at
    super.in_time_zone if super
  end
  
end
