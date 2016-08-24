# encoding: utf-8
class ConfirmationsController < Devise::ConfirmationsController
  layout "blank"
# GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if self.resource.subuser == true
      redirect_to edit_subuser_user_path(self.resource)
      return
    end
    yield resource if block_given?

    if resource.errors.empty?
      if resource.account.approved
        set_flash_message(:notice, :confirmed) if is_flashing_format?
      else
        set_flash_message(:notice, :confirmed_but_not_approved) if is_flashing_format?
      end
      respond_with_navigational(resource){
        redirect_to after_confirmation_path_for(resource_name, resource) 
      }
    else
      respond_with_navigational(resource.errors, :status => :unprocessable_entity){ render :new }
    end
  end
end

