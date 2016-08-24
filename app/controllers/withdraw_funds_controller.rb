class WithdrawFundsController < ApplicationController
  def process_order
    #raise params.inspect
    @bank = Bank.find_by(id: params[:bank])
    if @bank.present?
      @error = ""
      if params[:amount].present?
        if params[:amount].to_d != 0.0
          @amount = params[:amount]
           @account_balance = current_user.account.account_balances.where( "id = ?",params[:account_balance]

            ).first
           if @amount.to_f < @account_balance.balance
            @transaction = Transaction.new(to_account_id: current_user.account.id, 
                                          transaction_from: "User", 
                                          transaction_from_id: current_user.id,
                                            from_account_id: current_user.account.id,
                                             amount: ((params[:amount].present?) ? params[:amount].to_f : 0.0), 
                                             kaenko_currency_id: @account_balance.kaenko_currency.id,
                                             transaction_type: "Withdraw" , 
                                             user_id: current_user.id,
                                             status: "Completed"
                                            )
            
            begin
              Transaction.transaction do
                @account_balance.update_attributes(
                  balance: @account_balance.balance - ((params[:amount].present?) ? params[:amount].to_f : 0.0)
                )
                @transaction.roleable_id = @bank.id
                @transaction.roleable_type = "Bank"
                @transaction.save!
              end
            rescue => e
              @error = "Unable to withdraw funds. Try after sometime...."  
            end
          #UserMailer.withdraw_fund(current_user, @transaction).deliver
          else
            @error = "Amount must be less than currency balance"
          end
      else
        @error = "Please enter valid amount"  
      end
      else
        @error = "Please enter amount"
      end
    else
      @error = "Please select bank"
    end
  end  
end
