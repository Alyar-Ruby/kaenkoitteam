# encoding: utf-8
class Account < ActiveRecord::Base
  #validates_presence_of :pin, :security_question_answer, :user_security_question_id, 
  #:on=>"update", :if => Proc.new{|u| u.security_question_answer.present?}

  #validates :pin, confirmation: true, :on=>"update"
  
  has_many :users
  has_many :account_balances
  has_many :invites
  has_many :from_transactions, :class_name=>"Transaction", :foreign_key=>"from_account_id"
  has_many :to_transactions, :class_name=>"Transaction", :foreign_key=>"to_account_id"
  belongs_to :roleable, polymorphic: true
  has_one :premium_request
  belongs_to :kaenko_currency
  has_many :kaenko_currencies, :through => :account_balances

  mount_uploader :account_document, AccountDocumentUploader
  mount_uploader :account_id_document, AccountIdDocumentUploader
  mount_uploader :account_status_document, AccountStatusDocumentUploader

  has_many :conversation_messages, :dependent => :nullify
  has_many :conversation_users, :dependent => :nullify

  has_many :to_posts, :class_name=>"Account", 
           :foreign_key=>"to_account_id" 
  has_many :from_posts, :class_name=>"Account", 
           :foreign_key=>"from_account_id" 
  has_many :comments, :dependent => :destroy
  
  def max_invites
    if self.premium
      5
    else
      3
    end
  end


  def display_address
    if self.roleable_type == "Business"
      self.roleable.address
    else
      self.users.first.address
    end
  end


  def display_name
    if self.roleable_type == "Business"
      self.roleable.organization_name
    else
      self.users.first.name
    end
  end

  def display_email
    if self.roleable_type == "Business"
      self.roleable.email
    else
      self.users.first.email
    end
  end


  def display_image
    image = ""
    if self.roleable_type == "Business"
       image = self.roleable.image.present? ? self.roleable.image_url(:circle) : '/assets/av2.png'
    else
      image = self.users.first.image.present? ? self.users.first.image_url(:circle) : '/assets/av2.png'
    end
    image
  end

  def display_image_profile
    image = ""
    if self.roleable_type == "Business"
       image = self.roleable.image.present? ? self.roleable.image_url(:profile) : '/assets/av2.png'
    else
      image = self.users.first.image.present? ? self.users.first.image_url(:profile) : '/assets/av2.png'
    end
    image
  end

  def display_country
    country = ""
    if self.roleable_type == "Business"
       country = self.roleable.country
    else
      country = self.users.first.country
    end
    country
  end
  def display_country_name
    country = ""
    if self.roleable_type == "Business"
       country = self.roleable.country
    else
      country = self.users.first.country
    end
    country_name(country)
  end


  def display_city
    city = ""
    if self.roleable_type == "Business"
       city = self.roleable.city
    else
      city = self.users.first.city
    end
    city
  end

  def display_website
    website = ""
    if self.roleable_type == "Business"
       website = self.roleable.business_websites.where(is_primary: true).first.try(:website_url)
    else
      website = self.users.first.website_url
    end
    website.present? ? website.sub(/^https?\:\/\//, '').sub(/^www./,'') : ""
  end

  def online_status
    online_staus = false
    if self.roleable_type == "Business"
      online_status = self.users.where("online_status = ?", true).size > 0 ? true : false
    else
      online_staus = self.users.first.online_status
    end
      online_staus
  end

  def country_name(alpha2)
    if alpha2.present?
      country = Country.find_country_by_alpha2(alpha2)
      country ? country.name : nil
    else
      ""
    end
  end

  def self.search(query)
    @accounts = Account.find_by_sql("
    (select accounts.* from accounts LEFT JOIN users ON users.account_id = accounts.id 
      where accounts.roleable_type = 'Personal' and (users.first_name ILIKE '%"+ query +"%'
      or users.last_name ILIKE '%"+ query +"%' or split_part(users.email, '@', 1) ILIKE '%"+ query +"%')
    )

    UNION

    (select accounts.* from accounts LEFT JOIN businesses ON accounts.roleable_id = businesses.id 
      where accounts.roleable_type = 'Business'
      and (businesses.organization_name ILIKE '%"+ query +"%' 
      or businesses.organization_url ILIKE '%"+ query +"%'
      or split_part(businesses.email, '@' , 1) ILIKE '%"+ query +"%' 
      or businesses.category_id in (select id from categories where name ILIKE '%"+ query +"%') 
      or businesses.sub_category_id in (select id from categories where name ILIKE '%"+ query +"%') )
    )")
  end

  def social_profile_name(account_id)
    social_name = ""
    if self.roleable_type == "Business"
      social_name =  (self.id == account_id) ? "My Business Profile" : "#{self.display_name} Profile"
    else
       social_name = (self.id == account_id) ? "My Profile" : "#{self.display_name} Profile"
    end
     social_name
  end



end
