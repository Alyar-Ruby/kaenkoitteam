# encoding: utf-8
class Admins::RegistrationsController < Devise::RegistrationsController
	skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  skip_before_filter :check_subdomain
  layout "admin"
  
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      yield resource if block_given?
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      flash[:notice] = "Password Updated."
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def after_update_path_for(resource)
    {:controller=>"admins/homes", :action=>"index"}
  end
  
end
