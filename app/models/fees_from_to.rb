# encoding: utf-8
class FeesFromTo < ActiveRecord::Base
  validates_presence_of :from_account, :to_account, :mode
end
