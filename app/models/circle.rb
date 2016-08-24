# encoding: utf-8
class Circle < ActiveRecord::Base
	
	#  ===============
  #  = Validations =
  #  ================
  
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
	
	#  ================
  #  = Associations =
  #  ================
  belongs_to :owner, :class_name=>"User", :foreign_key=>"owner_id"
	has_many :circle_users
	has_many :users, through: :circle_users, dependent: :destroy
	
	# Setup accessible  attributes for your model
	attr_reader :user_tokens
	attr_reader :user_email
	
	#===========================================
	#=== inserting user_ids in user_circles ====
	#===========================================
	def user_tokens=(ids)
	  self.user_ids = ids.split(",")
	end
	
	def user_email=(emails)
		ids = []
		emails.split(",").each do |email|
			user = User.find_by_email(email.downcase.strip)
			ids << user.id if user.present?
		end
		self.user_ids = ids
	end
end
