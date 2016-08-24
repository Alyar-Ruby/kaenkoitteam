# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable,  :rememberable, :trackable, :validatable, :lockable


  
  #extend FriendlyId
  #friendly_id :username
 #  ================
 #  = Validations =
 #  ================
  validates_presence_of  :first_name, :last_name, :gender, :date_of_birth,
    :nationality, :country, :phone, :allow_nil => true

  validates :username, :presence => true, :allow_nil => true
  validates :address, :presence => true, :allow_nil => true
  validates :city, :presence => true, :allow_nil => true
  validates :postal_code, :presence => true, :allow_nil => true

  #validates_presence_of :representative_position,
  # :if => Proc.new{|u| u.roleable_type.downcase == "business"}
  validates_uniqueness_of :username, :if => lambda {|p| p.username.present?}
  validates :email, confirmation: true
  validates :security_pin, :presence => true, length: {is: 4}, numericality: true,  :allow_nil => true 
  validates :pin, length: {is: 6}, :allow_nil => true
  validates :user_security_question_id, :presence => true, :allow_nil => true
  validates :secret_question_answer, :presence => true,  :allow_nil => true

  validate :check_avatar_dimensions
  

  
  #  ================
  #  = Associations =
  #  ================
  belongs_to :account

  has_many :from_notifications, :class_name=>"KaenkoNotification", 
           :foreign_key=>"from_user_id" 
  has_many :to_notifications, :class_name=>"KaenkoNotification",
           :foreign_key=>"to_user_id" 
  has_many :from_connections, :class_name=>"Connection", 
           :foreign_key=>"from_user_id" 
  has_many :to_connections, :class_name=>"Connection", 
           :foreign_key=>"to_user_id" 
  has_one :premium_request, :dependent => :nullify
  has_many :timelines, :dependent => :nullify
  has_many :transactions, :dependent => :nullify
  has_many :conversation_messages, :dependent => :nullify
  has_many :conversation_users, :dependent => :nullify
  has_many :circle_users, :dependent => :nullify
  has_many :circles, :through => :circle_users, dependent: :destroy

  has_many :user_referrals, dependent: :destroy
  has_many :owned_circles, :class_name=>"Circle", 
           :foreign_key=>"owner_id", :dependent => :nullify
  has_many :request_payments, :dependent => :nullify
  has_many :invoices, :dependent => :nullify
  has_many :banks, :dependent => :nullify
  has_many :cards, :dependent => :nullify
  has_and_belongs_to_many :roles
  has_many :user_capabilities, :dependent => :nullify
  has_many :capabilities, through: :user_capabilities, :dependent => :nullify

  has_many :to_posts, :class_name=>"User", 
           :foreign_key=>"to_user_id" 
  has_many :from_posts, :class_name=>"User", 
           :foreign_key=>"from_user_id" 
  has_many :comments, :dependent => :destroy
  belongs_to :user_security_question
  
  
  accepts_nested_attributes_for :premium_request

  attr_accessor :avatar_upload_width, :avatar_upload_height

  #  ================
  #  === Uploader ===
  #  ================

  mount_uploader :image, UserImageUploader
  mount_uploader :address_document, UserAddressDocumentUploader

  #  ================
  #  ==== Scope =====
  #  ================
  scope :admin_user, ->{ where(account_admin: true) } 
  
  def full_details
    if self.image.present?
      user_image = self.image_url(:circle)
    else
      user_image = '/assets/av-mark.jpg'
    end
    # '<div class="clearfix">
    #   <div class="notif_thumb pull-left">
    #    <img src="'+user_image+'" width="50px" height="50px" class="img-circle">
    #   </div>
    #    <div class="notif_content pull-right">
    #     <div class="notif_author">
    #     '+self.name+'
    #     </div>
    #     <div class="notif_snippet">
    #     [user snippet]
    #     </div>
    #     <div class="notif_timestamp">
    #     '+Connection.user_all_connection(self).count.to_s+'
    #     <div>
    #    </div>
    #   </div>'.html_safe
    '<div class="display_box" align="left">
        <img src="'+user_image+'" style="width:50px; height:50px; float:left; margin-right:6px;" class="img-circle" />
        <span class="name">
          '+self.name+'
        </span>
      </div>'
  end

  def name
    name = self.first_name
    name = name + " " + self.middle_name if self.middle_name.present?
    name = name + " " + self.last_name if self.last_name.present?
  end
  
  def mailboxer_email(email)
  end

  def nation
    Country.find_country_by_alpha2(self.nationality).name
  end
  
  def full_address
    country = Country.find_country_by_alpha2(self.country)
    state = country.states[self.state]["name"] if country.present? and self.state.present?
    full_address = self.address
    full_address = full_address + ",<br>" + self.city if self.city.present?
    full_address = full_address + ",<br>" + state if state.present?
    full_address = full_address + ",<br>" + country.name if country.present?
    full_address = full_address + " - " + self.postal_code if self.postal_code.present?  
    full_address.html_safe  
  end
      
  def is_active?
    self.account.approved && self.account.active && self.active
  end
  
  def active_for_authentication?
    super && self.is_active? # i.e. super && self.is_active
  end

  def inactive_message
    if !self.account.approved
      if self.confirmed_at.present?
        if self.premium_request.status == "pending"
          "Your Premium Request is under Approval Process. You will get an email once approved."
        elsif self.premium_request.status == "rejected"
          "Your Premium Request has been rejected. Check email for the Rejection Reason."
        else
          super
        end
      else
        super
      end
    elsif !self.account.active
      "Your account has been deactivated. Contact Kaenko."
    elsif !self.active
      "Your login has been deactivated. Contact Kaenko if you are the Account Admin else contact Account Admin."
    else
      super
    end
  end  
  
  def pending_transactions
    @transaction = Transaction.where("transaction_to = ? and status = 'pending'",self.email)
    if @transaction.present?
      @transaction.update_all(:to_account_id=>self.account.id)
    end
  end
  
  def _account_type
  	self.account.roleable_type
  end
  
  def user_account
 	  self.account.roleable
  end

  def business_name
    name = ""
    if self._account_type == "Business"
      name = self.account.roleable.organization_name
    elsif self._account_type == "Personal"
      name = self.name
    end
      name
  end
 
  def user_image
 	  image =""
    if self._account_type == "Business"
      image = self.account.roleable.image_url(:circle)
    elsif self._account_type == "Personal"
      image = self.image_url(:circle)
    end
    #raise image.inspect
      image
  end

  def check_avatar_dimensions
    if self.avatar_upload_width.present? && self.avatar_upload_height.present? 
      if (self.avatar_upload_width <= 375) && (self.avatar_upload_height <= 375)
        errors.add(:image, "Dimensions of uploaded avatar should be greater than 375x375 pixels." )
      end
    end
  end


  def user_permission(permission_title)

    allowed = false
    permission = self.roles.where("title = ?", permission_title)
    allowed =  ((permission.size > 0) || self.is_admin == true) ? true : false
    allowed
  end

  def is_admin
    user = self.account.users.where("account_admin = ?" , true).first
    admin = (user.id == self.id)
    admin
  end

  #===== overidden method to get date in timezone ====

  def created_at
    super.in_time_zone if super
  end

  def updated_at
    super.in_time_zone if super
  end

  def last_sign_in_at
    super.in_time_zone if super
  end

end






















