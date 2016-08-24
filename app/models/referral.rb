# encoding: utf-8
class Referral < ActiveRecord::Base

  validates_presence_of :account_type, :commission_level
  validate :valid_commission_level
	before_save :manage_commission_level
	
  #===========================
  #=======store commission_level as key value pair======
  #===========================
	def manage_commission_level
		if self.commission_level.present? && !self.commission_level.empty?
   		sum = 0
			level = 0
      _commission_level = {}
    	self.commission_level.each do |k, v| 
    		level = level + 1
        _commission_level[level] = v
    		sum = sum + v.to_d
    	end
      self.commission_level = _commission_level
    	self.levels = level
    	self.commission = sum
    end
	end

  def valid_commission_level
    if self.commission_level.present?
      self.commission_level.each do |k, v|
        if !v.present?
          errors[:commission_level] << "can't be blank"
          break;
        end
      end
    end
  end
end
