class Post < ActiveRecord::Base
	belongs_to :to_user, :class_name=>"User", 
           :foreign_key=>"to_user_id" 
  belongs_to :from_user, :class_name=>"User", 
           :foreign_key=>"from_user_id" 

  belongs_to :to_account, :class_name=>"Account", 
           :foreign_key=>"to_account_id" 
  belongs_to :from_account, :class_name=>"Account", 
           :foreign_key=>"from_account_id" 

  has_many :comments, :dependent => :destroy


  def created_at
    super.in_time_zone if super
  end

  def updated_at
    super.in_time_zone if super
  end
  
end
