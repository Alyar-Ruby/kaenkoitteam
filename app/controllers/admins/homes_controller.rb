# encoding: utf-8
class Admins::HomesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :authenticate_admin!
  layout "admin"
  before_filter "active_tab('Dashboard')"
  
  def index
  end
  
  def list_states
    if params[:country_2_code].present?
      all_states = [["", "Select State/Province"]]
      Country.find_country_by_alpha2("#{params[:country_2_code]}").states.sort.map { |state|
        all_states << ["#{state[0]}", "#{state[1].first[1]}"]
      }
      render :json => all_states
    else
      render :text => "Please select a country to continue..."
    end
  end
end
