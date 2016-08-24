# encoding: utf-8
class KaenkoSetting < ActiveRecord::Base
  validates_presence_of :timezone, :date_time, :business_commission
end
