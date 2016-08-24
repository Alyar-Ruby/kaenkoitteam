# encoding: utf-8
class UserReferral < ActiveRecord::Base
	#================
 	#  = Validations =
 	#================
	validates :email , presence: true, uniqueness: true

	#  ================
  #  = Associations =
  #  ================
	belongs_to :user

	#  ================
  #  = callbacks =
  #  ================

  before_save :check_existing_user

  def check_existing_user
  	user = User.where("email = ?", self.email)
  	user.size > 0 ? errors.add(:email, "Email is already registered, Please add another user email."): ""
  end

end
