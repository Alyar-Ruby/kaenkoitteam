class AddFundsController < ApplicationController

  def new_order
    if params[:card] == "new-card"
      @card = params[:card]
    else
      @card = Card.find_by_id(params[:card]) if params[:card].present?
    end
  end

  def process_new_card
    @error = ""
    if params[:amount].present?
      if params[:amount].to_d != 0.0 
        params[:card][:expiry_date] = "01/"+params[:card][:expiry_date]
        @amount = params[:amount]
        @card = current_user.cards.new(card_params)
        @card.card_type = "MasterCard"
        @account_balance = current_user.account.account_balances.where(
            "kaenko_currency_id = ?",
             params[:kaenko_currency_id]
          ).first
          @transaction = Transaction.new(to_account_id: current_user.account.id, 
                                        transaction_from: "User",
                                        transaction_from_id: current_user.id,  
                                          from_account_id: current_user.account.id,
                                           amount: ((params[:amount].present?) ? params[:amount].to_f : 0.0), 
                                           kaenko_currency_id: params[:kaenko_currency_id],
                                           transaction_type: "AddFund" , 
                                           user_id: current_user.id,
                                           status: "Completed")
       
          begin
            Transaction.transaction do
              @card.save!
              @transaction.roleable_id = @card.id
              @transaction.roleable_type = "Card"
              @transaction.save!
               if @account_balance.present?
                @account_balance.update_attributes(
                   balance: @account_balance.balance + ((params[:amount].present?) ? params[:amount].to_f : 0.0)
                )
              else
                @account_balance = current_user.account.account_balances.new(
                  kaenko_currency_id: params[:kaenko_currency_id], 
                  balance: ((params[:amount].present?) ? params[:amount].to_f : 0.0)
                  ).save!
              end
            end
          rescue => e
            @error =  "Unable to process add funds, Try after sometime."
          end
          #UserMailer.send_add_funds(current_user, @transaction).deliver
      else
        @error = "Please enter valid amount"
      end  
    else
      @error = "Please enter amount"
    end
  end

  def process_existing_card
    @error = ""
    if params[:amount].present?
       if params[:amount].to_d != 0.0 
        @card = Card.find(params[:card])
        @amount = params[:amount]
         @account_balance = current_user.account.account_balances.where(
            "kaenko_currency_id = ?",
             params[:kaenko_currency_id]
          ).first
          
          @transaction = Transaction.new(to_account_id: current_user.account.id, 
                                        transaction_from: "User",
                                        transaction_from_id: current_user.id,  
                                          from_account_id: current_user.account.id,
                                           amount: ((params[:amount].present?) ? params[:amount].to_f : 0.0), 
                                           kaenko_currency_id: params[:kaenko_currency_id],
                                           transaction_type: "AddFund" , 
                                           user_id: current_user.id,
                                           status: "Completed"
                                          )
       
          begin
            Transaction.transaction do
              @transaction.roleable_id = @card.id
              @transaction.roleable_type = "Card"
              @transaction.save
              if @account_balance.present?
                @account_balance.update_attributes(
                   balance: @account_balance.balance + ((params[:amount].present?) ? params[:amount].to_f : 0.0)
                )
              else
                @account_balance = current_user.account.account_balances.new(
                  kaenko_currency_id: params[:kaenko_currency_id], 
                  balance: ((params[:amount].present?) ? params[:amount].to_f : 0.0)
                  ).save
              end
            end
          rescue => e
            @error =  "Unable to process Withraw, Try after sometime."
          end
          #UserMailer.send_add_funds(current_user, @transaction).deliver
      else
        @error = "Please enter valid amount"  
      end
    else
      @error = "Please enter amount"
    end
  end


  def card_params
    params.require(:card).permit(:name, :card_number, :expiry_date, :cvv)
  end

end
