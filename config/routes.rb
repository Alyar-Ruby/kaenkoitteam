Kaenko::Application.routes.draw do
  get "privatechat/index"
  resources :privatechat, :except => [ :index, :create, :new, :edit, :show, :update, :destroy ] do
    collection do
      get :start_chat_session
    end
  end


	post 'public/new_message'
  get "public/index"
  
  devise_for :admins, :constraints => {:subdomain => 'bo.development'}, 
  controllers: { sessions: "admins/sessions" , passwords: "admins/passwords" , registrations: "admins/registrations" }, 
  :path => "/"

  
  devise_for :users, :controllers => {:registrations => "registrations", :confirmations => "confirmations", :sessions => "sessions", :passwords=>"passwords", :unlocks=>"unlocks"}, :path => "", :path_names => { :sign_out => 'logout'}
  
  devise_scope :admin do
    get "/login" => "devise/sessions#new"
    match 'admins/change_password' => 'admins/registrations#edit', :via=>[:get]
  end
  
  devise_scope :user do
    match 'change_password' => 'registrations#change_password', :as=>"change_password", :via=>[:get]
    
    match 'profile/:username' => 'registrations#profile', :as=>"view_profile", :via=>[:get]
    
    match 'member/sign_up' => 'registrations#member', :user => { :roleable_type => 'member' }, :via=>[:get]
    match 'personal/sign_up' => 'registrations#new', :user => { :roleable_type => 'personal' }, :via=>[:get]
    match 'business/sign_up' => 'registrations#new', :user => { :roleable_type => 'business' }, :via=>[:get]
    match 'premium/request' => 'registrations#new', :user => { :roleable_type => 'premium' }, :via=>[:get]
    
    match 'member/sign_up' => 'registrations#create_member', :roleable_type => 'member' , :via=>[:post]
    match 'personal/sign_up' => 'registrations#create', :roleable_type => 'personal' , :via=>[:post]
    match 'business/sign_up' => 'registrations#create', :roleable_type => 'business' , :via=>[:post]
    match 'premium/request' => 'registrations#create', :roleable_type => 'premium' , :via=>[:post]
    match '/confirm/:confirmation_token' => "confirmations#show", :as => "user_confirm", :via=>[:get]
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  constraints subdomain: ["development",""] do
    # You can have the root of your site routed with "root"
    match 'list_states' => 'homes#list_states', :as=>"list_states", :via=>["get"]
    match 'search_users' => 'homes#search_users', :as=>"search_users", :via=>["get"]
    get 'dashboard_overview' => 'homes#dashboard_overview'
    get 'dashboard_payment' => 'homes#dashboard_payment'
    get 'dashboard_history' => 'homes#dashboard_history'
    get 'groups' => 'homes#groups'
    get 'add_funds' => 'homes#add_funds'
    get 'withdraw' => 'homes#withdraw'
    get 'exchange' => 'homes#exchange'
    get 'sell_online' => 'homes#sell_online'    
    get 'referrals' => 'user_referrals#index'
    match 'account_setting' => 'accounts#index', :as=>"account_setting", :via=>["get"]
    match 'account_setup' => 'accounts#account_setup', :as=>"account_setup", :via=>["get"]
    match 'account_setting' => 'accounts#update', :as=>"update_setting", :via=>["put"]
    match 'update_security' => 'accounts#update_security', :as=>"update_security", :via=>["put"]
    match 'verify' => 'accounts#verify', :as=>"verify", :via=>["get"]
    match 'verified' => 'accounts#verified', :as=>"verified", :via=>["post"]
    get 'auth/:provider/callback' => 'homes#user_list'
    get 'auth/failure' => "homes#user_failure"
    get 'list_subcategory' => "businesses#list_subcategory" 
    resources :businesses do
      member do
        get 'edit_address'
        put 'update_address'
        get 'edit_business_detail'
        put 'update_business_detail'
        get 'edit_business_address_document'
        get 'edit_business_document'
        put 'update_field'
        get 'update_country'
        get 'businesss_update'
        get 'update_city_postal'
        get 'update_email'
        get 'update_phone'
        get 'update_address'
        get 'update_region'
        get 'update_name'
        get 'edit_business_contact'
        put 'update_contact'
        get 'update_desc'

      end
      collection do
        post 'verify_address_document'
        post 'upload_business_document'
        post 'update_image'

      end
    end
    resources :invites
    resources :kaenko_notifications do
      collection do
        get 'notification_check'
        get 'delete_notification'
        get 'unread_notification'
        get 'total_notification'

      end
    end
    resources :accounts do
      member do
        get 'edit_account_document'
        get 'edit_account_id_document'
        get 'edit_status'
        get :update_popup_time_zone
        get :privacy_settings
        get :email_notification
      end  
      collection do
        get :update_currency
        post :upload_account_document
        post :upload_account_id_document
        get :update_time_zone

      end
      resources :account_chats, only: [:new, :create, :destroy] do
        member do
          get :load_message
          get :load_search_msg
        end
      end
      resources :add_funds do
        collection do
          get :new_order
          post :process_new_card
          post :process_existing_card

        end
      end
      resources :withdraw_funds do
        collection do
          post :process_order

        end
      end
    end
    resources :premium_requests
    resources :messages do
      collection do
        get :to_user
        get :autocomplete_user_email
        get :total_messages
        get :archive_list
        get :unread_list
        get :total_messages
        get :popup_messages
        get :message_recent
        get :search_message
        get :show_archive
        get :unread_message

      end
      member do
        get :trash_show_message 
        post :reply
        post :trash
        post :archive
        get :search_within_message
        post :reply_archive
        get :archive_detail
        get :unread_detail
        post :export_conversation
        post :download_attachment
      end
    end
    root 'homes#index'
    resources :transactions do
      member do
        get 'accept'
        get 'reject'
        get 'cancel'
        get 'popup_i_withdraw'
        get 'popup_i_addfund'
        get 'popup_i_payment'
        get 'refund'
        get 'issue_refund'
        post 'create_issue_refund'
      end
      collection do
        post 'review_send_money'
        get 'send_money'
        get 'pending'
        post 'circle_transaction'
      end
      resources :disputes do
        member do
          get 'accept_solution'
          get 'modify_solution'
          post 'modify_dispute_refund'
          post 'accept_dispute_refund'
        end
      end
    end
    resources :circles
    resources :user_referrals
    resources :online_users, only: [:index]
    resources :request_payments do
      member do
        get :pay_request
        get :cancel_request
      end
    end
    resources :invoices do
      member  do 
        get 'pay_invoice_payment'
        get 'cancel_request'
      end
    end
    resources :account_payment_settings , only: [:index]
    resources :banks do
      member do
        get :confirm_delete
        post :confirm_delete
        get :make_primary
      end
    end
    resources :cards do
      member do
        get :confirm_delete
        post :confirm_delete
        get :make_primary
      end
    end
    resources :users do
    	member do
    		get 'social'
        get 'edit_secret'
        put 'update_secret'
        get 'edit_address'
        put 'update_address'
        get 'edit_contact'
        put 'update_contact'
        get 'suspend_account'
        get 'edit_personal_address'
        put 'update_personal_address'
        get 'edit_address_document'
        get 'edit_subuser'
        put 'update_subuser'
        get 'edit_security_pin'
        put 'update_security_pin'
        get 'update_email'
        get 'update_country'
        get 'update_city_postal'
        get 'update_user_dob'
        get 'update_user_gender'
        get 'edit_permission'
        get 'update_permission'
        get 'edit_personal_subuser'
        get 'update_phone'
        get 'update_first_name'
        get 'update_last_name'
        get 'update_job_title'
        post 'upload_subuser_image'
        put 'update_secret_ques'
        put 'update_secret_ans'
        put 'update_secret_pin'
        put 'update_pay_out_over'
        get 'ask_security_pin'
        get 'check_pin'
        get 'social_message'
        get 'update_about_me'
        post 'create_social_message'


    	end
    	collection do
        get 'edit'
    		get 'advance_search'
        post 'update_image'
        get 'update_online_status'
        post 'verify_address_document'
        put 'update_language'
        post 'autocomplete_user'
        get 'search_connection'


    	end
    end
    resources :connections do
      collection do
        get 'pending_connection'
      end
      member do
        get 'approve_reject'
      end
    end
    get 'update_server' => 'homes#update_server'
    resources :posts do
      member do
        get 'make_private'
        get 'make_public'
      end
      resources :comments
    end
    resources :account_currencies do
      collection do
        get 'show_currency'
      end
      member do
        get 'remove_currency'
      end


    end
    resources :business_websites
    resources :payments do
      collection do
        get :expected_pay_outs
      end
    end
    resources :sell_onlines do
      collection do
        get 'dispute_glossary'
        get 'customer_glossary'
        get 'review_glossary'
        get 'seller'
        get 'tools'
      end
    end

    
  end

  constraints(:subdomain => 'bo.development') do
    scope module: :admins do
    #namespace :admins, :path => '/' do
      match 'settings' => 'kaenko_settings#index', :as=>"kaenko_setting", :via=>["get"]
      match 'settings/edit' => 'kaenko_settings#edit', :as=>"edit_kaenko_setting", :via=>["get"]
      match 'settings' => 'kaenko_settings#update', :as=>"update_kaenko_setting", :via=>["put","patch"]
      match 'list_states' => 'homes#list_states', :as=>"admin_list_states", :via=>["get"]
      
      resources :users do
        member do
          get 'active_inactive'  
          get 'user_details'
        end
      end
      resources :businesses 
      resources :premium_requests do
        member do
          get 'approve'
          get 'reject'
        end
      end
      resources :faqs
      resources :referrals
      resources :earnings
      resources :fees_redemptions
      resources :fees_uploads
      resources :fees_from_tos
      resources :fees_exchanges
      resources :orders
      resources :transactions
      resources :timelines
      resources :api_clients
      get '', to: 'homes#index'
      #root 'homes#index'
    end
  end
    
  constraints :subdomain => 'api' do
    mount API::Base => '/'
  end


end
