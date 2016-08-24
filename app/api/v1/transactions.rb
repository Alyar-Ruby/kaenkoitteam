module API
  module V1
    class Transactions < Grape::API
      include API::V1::Defaults
       resources :transactions do
       	#get all the transactions of the user
        get do
       		 authenticate!
       		 transactions = current_user.account.from_transactions.order("created_at desc")	
       		 transactions = transactions.map do |_transaction|
       		 	{ transaction_id: _transaction.transaction_id, 
              transaction_to: _transaction.transaction_to, 
              transaction_from: _transaction.transaction_from, amount: _transaction.amount, 
              currency: _transaction.kaenko_currency.unit, status: _transaction.status 
            }
       		 end
       	end
        
        #get details of the transaction
        get :details do
          authenticate!
          transaction = Transaction.where("transaction_id = ?",params[:transaction_id]).first
          if transaction.present?
            if (transaction.to_account_id == current_user.account_id or transaction.from_account_id == current_user.account_id)
              { transaction_id: transaction.transaction_id, 
                transaction_to: transaction.transaction_to,
                amount: transaction.amount, currency: transaction.kaenko_currency.unit, 
                status: transaction.status, transaction_type: transaction.transaction_type 
              }
            else
              {error: "You are not authorized to view details of this transaction"}
            end
          else
            {error: "No Such Transaction Exists"}
          end
        end
        
        #return all the transactions pending for your acceptance
       	get :pending do
       		 authenticate!
       		 transactions = current_user.account
                                      .to_transactions
                                      .where("status = 'pending'").order("created_at desc")
       		 transactions = transactions.map do |_transaction|
       		 	{ transaction_id: _transaction.transaction_id, 
              transaction_to: _transaction.transaction_to, 
              transaction_from: _transaction.transaction_from, 
              amount: _transaction.amount, currency: _transaction.kaenko_currency.unit, 
              status: _transaction.status 
            }
       		 end
       	end
        
        #return account balances for all currencies
        get :account_balance do
          authenticate!
          balances = current_user.account.account_balances.order("id asc")	
          balances = balances.map do |_balance|
            { balance: _balance.balance, currency: _balance.kaenko_currency.unit }
          end
        end
        
        #accept the pending transaction
       	get :accept do
          authenticate!
          transaction = current_user.account.to_transactions
                                    .where("transaction_id = ? and status = 'pending'",
                                      params[:transaction_id]
                                    ).first
          if transaction.present?
            account_balance = current_user.account.account_balances
                                          .where("kaenko_currency_id = ?",
                                            transaction.kaenko_currency_id
                                          ).first
            if account_balance.present?
              account_balance.update_attributes(
                :balance=>account_balance.balance+transaction.amount.to_f
              )
            else
              account_balance = current_user.account
                                            .account_balances.new(
                                              :kaenko_currency_id=>transaction.kaenko_currency_id, 
                                              :balance=>transaction.amount.to_f
                                            ).save
            end
            transaction.update_attributes(:status=>"completed")        
            {status: "Transaction Accepted"}
          else
            {error: "No Such Transaction Pending"}
          end
       	end

        #reject the pending transaction
       	get :reject do
          transaction = current_user.account.to_transactions
                                            .where("transaction_id = ? and status = 'pending'",
                                              params[:transaction_id]
                                            ).first
          if transaction.present?
            sender_balance = transaction.from_account
                                        .account_balances
                                        .where("kaenko_currency_id = ?",
                                          transaction.kaenko_currency_id
                                        ).first
            if sender_balance.present?
              sender_balance.update_attributes(
                  :balance=>sender_balance.balance+transaction.amount.to_f
              )
            else
              sender_balance = transaction.from_account
                                          .account_balances.new(
                                            :kaenko_currency_id=>transaction.kaenko_currency_id,
                                            :balance=>transaction.amount.to_f
                                          ).save
            end
            transaction.update_attributes(:status=>"rejected")            
            {status: "Transaction Rejected"}
          else
            {error: "No Such Transaction Pending"}
          end
        end

        #cancel the pending transaction
       	get :cancel do
          transaction = current_user.account.from_transactions
                                            .where("transaction_id = ? and status = 'pending'",
                                              params[:transaction_id]
                                            ).first
          if transaction.present?
            account_balance = current_user.account.account_balances
                                                  .where("kaenko_currency_id = ?",
                                                    transaction.kaenko_currency_id
                                                  ).first
            if account_balance.present?
              account_balance.update_attributes(
                               :balance=>account_balance.balance+transaction.amount.to_f
                              )
            else
              account_balance = current_user.account
                                            .account_balances.new(
                                              :kaenko_currency_id=>transaction.kaenko_currency_id, 
                                              :balance=>transaction.amount.to_f
                                            ).save
            end
            transaction.update_attributes(:status=>"cancelled")            
            {status: "Transaction Cancelled"}
          else
            {error: "No Such Transaction Pending"}
          end
        end
        
        #send money to any kaenko user
       	post :send_money do
       		authenticate!
       		error = ""
    			kaenko_currency = KaenkoCurrency.where(:unit=>params[:kaenko_currency]).first
					if !kaenko_currency.present?
						error = "Invalid Currency"
					end
					kaenko_user = User.where(:email=>params[:transaction_to]).first
                
          if kaenko_user.present? and kaenko_user.account_id == current_user.account_id
            error = "Can't send money to your own account"
          end
          
					if error.blank?
						output_check = check_funds(kaenko_currency, params[:amount].to_f)
						if output_check['error'].present?
							output_check['error']
						else
							@_payment_methods = output_check['payment_methods']
			
							@_payment_methods.each do |payment_method|
								account_balance = current_user.account
                                              .account_balances
                                              .where("id = ?",payment_method["balance_id"])
								if account_balance.present?
									account_balance = account_balance.first
									account_balance.update_attributes(
                    :balance=>(account_balance.balance-payment_method["balance_used"].to_f)
                  )
								end
							end
					
							@transaction = Transaction.new()
							@transaction.from_account_id = current_user.account.id
							@transaction.transaction_from = current_user.email
							@transaction.transaction_type = "send money"
							@transaction.status = (kaenko_user.present?) ? "completed" : "pending"
							@transaction.user_id = current_user.id
							@transaction.transaction_to = (kaenko_user.present?) ? 
                                            kaenko_user.email : params[:transaction_to]
							@transaction.to_account_id = (kaenko_user.present? and kaenko_user.account.present?) ? kaenko_user.account.id : 0
							@transaction.kaenko_currency_id = kaenko_currency.id
							@transaction.amount = params[:amount]
				
							if @transaction.save
                if kaenko_user.present?
                  @_reciever_account_balance = kaenko_user.account
                                                          .account_balances.where(
                                                            "kaenko_currency_id = ?",kaenko_currency.id
                                                          ).first
                  if @_reciever_account_balance.present?
                    @_reciever_account_balance.update_attributes(
                        :balance=>@_reciever_account_balance.balance+@transaction.amount.to_f
                      )
                  else
                    @_reciever_account_balance = kaenko_user.account
                                                            .account_balances.new(
                                                              :kaenko_currency_id=>kaenko_currency.id, 
                                                              :balance=>@transaction.amount.to_f
                                                            ).save
                  end
                end
                { transaction_id: @transaction.transaction_id, status: @transaction.status }
							else
								@_payment_methods.each do |payment_method|
									account_balance = current_user.account.account_balances.where("id = ?",payment_method["balance_id"])
									if account_balance.present?
									  account_balance = account_balance.first
									  account_balance.update_attributes(
                      :balance=>account_balance.balance+payment_method["balance_used"].to_f
                    )
									end
								end
								{error: "Unable to Process transaction. Please try after some time"}
							end
						end
					else
            {error: error}
					end
       	end
      end
    end
  end
end
