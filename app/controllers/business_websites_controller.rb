class BusinessWebsitesController < ApplicationController
  def new
    @business_website = business.business_websites.new
    @business_websites = business.business_websites
  end

  def create
    @business_website = business.business_websites.new
    @business_website.website_url =  "#{params[:business_website][:website_protocol]}#{business_params[:website_url]}"
    @error = ""
    if !@business_website.save
      @error = @business_website.errors.full_messages
    end
    @business_websites = business.business_websites
  end

  def update
    @error = ""
    @business_website = BusinessWebsite.find(params[:id])
    business.business_websites.update_all({is_primary: false})
    if !@business_website.update_attributes(is_primary: true)
      @error = @business_website.errors.full_messages.join("")
    end

  end

  def show_currency
    @account_currencies = account.account_currencies
  end

  private

  def business
    @business ||= current_user.account.roleable
  end

  def business_params
    params.require(:business_website).permit(:title, :website_url, :is_primary)
  end
end
