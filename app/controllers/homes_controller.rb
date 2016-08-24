# encoding: utf-8
class HomesController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only=>["index","list_states","user_list","user_failure"]
  respond_to :js, :html, :json
  
	def update_server
		system "pwd"
    system "git pull"
    system "touch tmp/restart.txt"
    render :layout => false
	end    
	
	def index
    if current_user.present?
      redirect_to  dashboard_overview_path
    else
      render :layout => false
    end
	end
    
	def dashboard_overview
    @current_tab = "dashboard"
    @account = current_user.account
    @account_balances ||= current_user.account.account_balances.where("kaenko_currency_id != ?",current_user.account.kaenko_currency_id).limit(2)
    @transactions ||= Transaction.where("(from_account_id = ? and parent_id is ?) or (to_account_id = ? and parent_id is ?)", @account.id,  nil, @account.id, nil).order("created_at desc")
	end

  def dashboard_payment
    @current_tab = "dashboard"
  end

  def dashboard_history
    @current_tab = "dashboard"
    currency = params[:currency].present? ? params[:currency] : 0.to_s
    batch_id = params[:batch_id].present? ? params[:batch_id] : 0.to_s
    if params[:commit].present?
      @transactions = current_user.transactions.where("transaction_type = ? or 
      status = ? or transaction_to = ? or transaction_id = ?", params[:type],
       params[:status], params[:email], batch_id).order("created_at desc").page(params[:page]).per(5)
    else
      @transactions = current_user.transactions.where("Date(created_at) >= ?", 30.days.ago.to_date).order("created_at desc").page(params[:page]).per(5)
    end
  end

  def social    
    @current_top_menu = "social"
    @current_tab = "social"
  end

  def add_funds
    @cards = current_user.cards.order("created_at desc")
    @current_tab = "add_funds"
  end
  
  def exchange
    @current_tab = "exchange"
  end
  
  def groups
    @current_tab = "account"
  end
  
  def sell_online
    @current_tab = "sell_online"
    @open_disputes = Dispute.where("(from_account_id = ? or to_account_id = ?) and is_resolved = ?", current_user.account.id, 
    current_user.account.id, false)
    @closed_disputes = Dispute.where("(from_account_id = ? or to_account_id = ?) and is_resolved = ?", current_user.account.id, 
    current_user.account.id, true)
  end
  
  def withdraw
    @current_tab = "withdraw"
    @banks = current_user.banks
    @account_balances = current_user.account.account_balances
  end
  
  # List states for selected country (using country_select gem)
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
  
  def user_list
  	auth = request.env["omniauth.auth"]
  	token = auth["credentials"]["token"]
 		user = FbGraph::User.me(token)
 		friends = user.friends
 		render :json => friends.size
 		return
		if friends.present?
			friends.each do |friend|
				FacebookFriend.create(email: friend.email)
			end
		end
  end
  
  def user_failure
  	render :json => params
  	return
  end
	
	def search_users
		@users = User.where("id != ? and email like ?", current_user.id, "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @users.map{|u| {:id=>u.id, :email=>u.email, :social=>social_user_url(u.id)}} }
    end
  end

  
end
