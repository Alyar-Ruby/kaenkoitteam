module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        version 'v1'
        format :json

        # global handler for simple not found case
        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        # global exception handler, used for error notifications
        rescue_from :all do |e|
          if Rails.env.development?
            raise e
          else
            Raven.capture_exception(e)
            error_response(message: "Internal server error", status: 500)
          end
        end
        helpers do
        	def clean_params(params)
    				ActionController::Parameters.new(params)
  				end
				  def authenticate!
      			error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    			end
					def current_user
						# find token. Check if valid.
						token = ApiKey.where(access_token: params[:token]).first
						if token && !token.expired?
						  @current_user = User.where("email =?" ,  token.api_client.email).first
						else
						  false
						end
					end
					def check_funds(kaenko_currency,transfer_amount)
						@output = Hash.new()
						@payment_methods = Array.new()
						currency_account_balance = current_user.account
																									 .account_balances
																									 .where(
																									 		:kaenko_currency_id=>kaenko_currency.id
																									 	).first
						@currency_balance = 0
						if currency_account_balance.present?
							@currency_balance = currency_account_balance.balance.to_f
						end
						@transfer_currency = kaenko_currency.id
						@transfer_currency_unit = kaenko_currency.unit
						@check_amount = 0
						@payment_method = Hash.new
						if @currency_balance >= transfer_amount
						
							@payment_method['balance_id'] = currency_account_balance.id
							@payment_method['balance_currency'] = currency_account_balance.kaenko_currency.unit
							@payment_method['balance_used'] = transfer_amount.to_s
							@payment_method['transfer_amount'] = transfer_amount.to_s
							@payment_method['transfer_currency'] = @transfer_currency_unit
						
							@payment_methods << @payment_method
							@output['payment_methods'] = @payment_methods
						else
							if @currency_balance > 0
								@check_amount = @check_amount + @currency_balance
								@payment_method['balance_id'] = currency_account_balance.id
								@payment_method['balance_currency'] = currency_account_balance.kaenko_currency.unit
								@payment_method['balance_used'] = @currency_balance.to_s
								@payment_method['transfer_amount'] = @currency_balance.to_s
								@payment_method['transfer_currency'] = @transfer_currency_unit
								
								@payment_methods << @payment_method
							end
						
							@remaining_amount = transfer_amount - @currency_balance
						
							@other_balances = current_user.account.account_balances
																						.where("kaenko_currency_id != ? and balance > 0",
																							kaenko_currency.id).order("id asc"
																						)
							@other_balances.each do |other_balance|
								@payment_method = Hash.new
						
								converted_amount = converted_currency(other_balance.balance, 
																		other_balance.kaenko_currency.unit, @transfer_currency_unit
																	 )
								
								if converted_amount >= @remaining_amount
								  converted_amount = converted_currency(@remaining_amount, 
								  											@transfer_currency_unit, 
								  											other_balance.kaenko_currency.unit
								  										)
								  @check_amount = @check_amount + @remaining_amount
								  
								  @payment_method['balance_id'] = other_balance.id
								  @payment_method['balance_currency'] = other_balance.kaenko_currency.unit
								  @payment_method['balance_used'] = converted_amount.to_s
								  @payment_method['transfer_amount'] = @remaining_amount
								  @payment_method['transfer_currency'] = @transfer_currency_unit
								  
								  @payment_methods << @payment_method
								  break
								else
								  @remaining_amount = @remaining_amount - converted_amount
								  @check_amount = @check_amount + converted_amount
								  
								  @payment_method['balance_id'] = other_balance.id
								  @payment_method['balance_currency'] = other_balance.kaenko_currency.unit
								  @payment_method['balance_used'] = other_balance.balance.to_s
								  @payment_method['transfer_amount'] = converted_amount
								  @payment_method['transfer_currency'] = @transfer_currency_unit
								  
								  @payment_methods << @payment_method
								end
							end
							if @check_amount < transfer_amount
								@output['error'] = "You don't have sufficient funds"
							else
								@output['payment_methods'] = @payment_methods
							end
						end
						@output
  				end #===== end check funds ====
  				
  				def converted_currency(amount, from_currency, to_currency)
  					Money.default_bank = Money::Bank::GoogleCurrency.new
    				Money.new(amount, from_currency).exchange_to(to_currency).fractional
  				end
      	end
      end
    end
  end
end
