# encoding: utf-8
class Admins::SessionsController < Devise::SessionsController

  skip_before_filter :verify_authenticity_token, :only => :destroy
  layout "admin_login"
end
