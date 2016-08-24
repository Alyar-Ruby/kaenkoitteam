# encoding: utf-8
class Invite < ActiveRecord::Base

  validates_presence_of :email, :account_id
  validates_uniqueness_of :email, :message=>"Invitation already sent"
  validate :max_invites
  belongs_to :account
  
  def max_invites
    invites = Invite.where("account_id = ?",self.account_id).count
    if invites.to_i >= self.account.max_invites.to_i
      errors[:max_count] << "You can only invite "+self.account.max_invites.to_s+" users for your account"
    end
  end
end
