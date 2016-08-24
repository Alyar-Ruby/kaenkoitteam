# encoding: utf-8
class BusinessesController < ApplicationController

  def edit_address
    @business = business
  end

  def update_address
    @business = business
    @business.update_attributes(business_params)
  end
  
  def edit
    if params[:id].to_s == current_user.account.roleable_id.to_s and current_user.account_admin
      @business = business
    else
      flash[:alert] = "You are not authorized to update other's Organization"
      redirect_to dashboard_url
    end
  end

  def edit_business_contact
     @business = business
  end
  
  def update_contact
    @business = business
    @business.update_attributes(business_params)
  end

  def list_subcategory
    @category = Category.find_by_id(params[:category_id])
    @sub_categories = @category.children if @category
    render :json => @sub_categories 
  end
  
  def update
    if params[:id].to_s == current_user.account.roleable_id.to_s and current_user.account_admin
      @business = business
      @business.update_attributes(business_params)
      flash[:notice] = "Organization Details successfully updated"
      redirect_to dashboard_url
    else
      flash[:alert] = "You are not authorized to update other's Organization"
      redirect_to dashboard_url
    end
  end

  def edit_business_address_document

  end
  def verify_address_document
    @business = business
    @business.address_document = params[:address_document]
    if @business.save
      @business.update_column(:address_verified, true)
      render :text => "Your Registered Address status is now Verified."
    else
      head :no_content, :status => :bad_request
    end
  end
  def edit_business_document

  end
  def upload_business_document
    @business = business
    @business.business_document = params[:business_document]
    if @business.save
      @business.update_column(:business_verified, true)
      render :text => "Your Business status is now Verified."
    else
      head :no_content, :status => :bad_request
    end
  end

  def update_field
    @business = business
    if business.update_attributes(business_params)
      render :text => "success"
    else
      head :no_content, :status => :bad_request
    end
    
  end

 
 
  def update_email
    @business = business
    @error = ""
    if !@business.update_attributes(business_params)
      @error = @business.errors.full_messages
    end

  end
  def update_phone
    @business = business
    @error = ""
    if !@business.update_attributes(business_params)
      @error = @business.errors.full_messages
    end

  end
  
  def update_name
    @business = business
    @error = ""
    if !@business.update_attributes(business_params)
      @error = @business.errors.full_messages
    end
  end

  def update_desc
    @business = business
    @error = ""
    if !@business.update_attributes(business_params)
      @error = @business.errors.full_messages
    end
  end
  
  def update_image
		@business = business
		@business.image = params[:business_pic]
	
		if @business.save
			render :json=>{:circle=>@business.image_url(:circle), :profile=>@business.image_url(:profile)}, layout: false
		else
			render :json =>{ :errors => @business.errors.full_messages.join("") }, :status => 422, :layout => false
		end
	end

  
  private

  def business_params
    params.require(:business).permit(:country_of_incorporation, :organization_name, 
                                      :organization_url, :legal_form, :registration_number, 
                                      :date_of_incorporation, :category_id, :sub_category_id, :country, :state, 
                                      :address, :city, :postal_code, :phone,  :admin_id, :email, :region, :description
                                    )
  end  

  def business
    current_user.account.roleable
  end
end
