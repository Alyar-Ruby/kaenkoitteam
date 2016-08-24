class Admins::AdminHomesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Dashboard')"
  
  def index
  end
end
