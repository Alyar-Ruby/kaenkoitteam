# encoding: utf-8
class Admins::BusinessesController < ApplicationController
	skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  before_filter :load_business
  layout "admin"

  def edit
  end

  def update
  	if @business.update_attributes(business_params)
  		redirect_to users_path
  	else
  		render :edit
  	end
  end

  private

  def business_params
  	params.require(:business).permit(:country_of_incorporation, 
                                :organization_name, :organization_url, :legal_form,
                                :registration_number, :date_of_incorporation, :industry, 
                                :country, :state, :address, :city, :postal_code, :admin_id
                                )
  end

  def load_business
  	@business = Business.find(params[:id])
  end
end
