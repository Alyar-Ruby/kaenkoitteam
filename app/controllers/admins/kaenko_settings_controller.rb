# encoding: utf-8
class Admins::KaenkoSettingsController < ApplicationController      
  skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  
  def index
    @kaenko_setting = KaenkoSetting.first
  end
  
  def edit
    @kaenko_setting = KaenkoSetting.first
  end
  
  def update
    @kaenko_setting = KaenkoSetting.first
    if @kaenko_setting.update_attributes(kaenko_setting_params)
      flash[:notice] = "Settings Updated"
      redirect_to kaenko_setting_path
    else
      render "edit"
    end
  end
  
  private

  def kaenko_setting_params
    params.require(:kaenko_setting).permit(:timezone, :date_time, :business_commission)
  end
end
