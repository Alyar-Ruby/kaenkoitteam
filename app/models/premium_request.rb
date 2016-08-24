# encoding: utf-8
class PremiumRequest < ActiveRecord::Base

  belongs_to :user
  belongs_to :account
  validates_presence_of :request
  validates_presence_of :comments, :if => Proc.new{|p| p.status != "pending"}
  
end
