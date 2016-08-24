# encoding: utf-8
class Admins::TimelinesController < ApplicationController
	skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Timelines')"
  
  def index
    @timelines = Timeline.order('id asc')
  end
end
