# encoding: utf-8
class Business < ActiveRecord::Base

  has_one :account, as: :roleable
  belongs_to :category
  has_many :business_websites
  
  validates_presence_of :country_of_incorporation, :organization_name, :organization_url, :legal_form, :registration_number, 
  :date_of_incorporation, :category_id, :country,  :address, :city, :postal_code
  validates_presence_of :commission, 
      :if => Proc.new{|p| p.account.premium and 
      p.account.premium_request.status == "approved" and
      p.account.roleable_type == "Business"}, :on=>"update"
 validate :check_avatar_dimensions


  mount_uploader :address_document, BusinessAddressDocumentUploader
  mount_uploader :business_document, BusinessDocumentUploader
  mount_uploader :image, BusinessImageUploader
  
  attr_accessor :avatar_upload_width, :avatar_upload_height
  
  def incorporation_country
    Country.find_country_by_alpha2(self.country_of_incorporation).name
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
  
  def check_avatar_dimensions
  if self.avatar_upload_width.present? && self.avatar_upload_height.present? 
    if (self.avatar_upload_width <= 375) && (self.avatar_upload_height <= 375)
      errors.add(:image, "Dimensions of uploaded avatar should be greater than 375x375 pixels." )
    end
  end
 end
end
