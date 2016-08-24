# encoding: utf-8
class TransactionsController < ApplicationController
	require 'money'
	require 'money/bank/google_currency'
  respond_to :js, :html, :json
  before_filter :find_transaction 
  
  def index
    @current_tab = "send_money"
    @transactions = current_user.account.from_transactions.order("created_at desc")
  end  
  
  def pending
    @transactions = current_user.account
                                .to_transactions.where("status = 'pending'")
                                .order("created_at desc")
  end
  
  def accept
    @transaction = current_user.account
                               .to_transactions
                               .where("id = ? and status = 'pending'",params[:id]).first
    if @transaction.present?
      @account_balance = current_user.account.account_balances.where(
                                      "kaenko_currency_id = ?",
                                       @transaction.kaenko_currency_id
                                      ).first
      if @account_balance.present?
        @account_balance.update_attributes(
                                      :balance=>@account_balance.balance+@transaction.amount.to_f
                                    )
      else
        @account_balance = current_user.account
                                      .account_balances.new(
                                        :kaenko_currency_id => @transaction.kaenko_currency_id, 
                                        :balance=>@transaction.amount.to_f
                                        ).save
      end
      @transaction.update_attributes(:status=>"completed")
      redirect_to pending_transactions_path, :notice=>"Transaction Accepted"
    else
      redirect_to pending_transactions_path, :alert=>"No Such Transaction available"
    end
  end
  
  def reject
    @transaction = current_user.account
                               .to_transactions.where("id = ? and status = 'pending'",params[:id]).first
    if @transaction.present?
      @sender_balance = @transaction.from_account
                                    .account_balances.where("kaenko_currency_id = ?",
                                        @transaction.kaenko_currency_id
                                      ).first
      if @sender_balance.present?
        @sender_balance.update_attributes(:balance=>@sender_balance.balance+@transaction.amount.to_f)
      else
        @sender_balance = @transaction.from_account.account_balances.new( 
          :kaenko_currency_id=>@transaction.kaenko_currency_id,
          :balance=>@transaction.amount.to_f).save
      end
      @transaction.update_attributes(:status=>"rejected")
      redirect_to pending_transactions_path, :notice=>"Transaction Rejected"
    else
      redirect_to pending_transactions_path, :alert=>"No Such Transaction available"
    end
  end
  
  def cancel
    @transaction = current_user.account.from_transactions
                                       .where("id = ? and status = 'pending'",params[:id]).first
    if @transaction.present?
      @account_balance = current_user.account.account_balances
                                      .where("kaenko_currency_id = ?",
                                              @transaction.kaenko_currency_id
                                            ).first
      if @account_balance.present?
          @account_balance.update_attributes(
                                      :balance=>@account_balance.balance+@transaction.amount.to_f)
                                          
      else
      @account_balance = current_user.account.account_balances.new(
                                              :kaenko_currency_id=>@transaction.kaenko_currency_id,
                                              :balance=>@transaction.amount.to_f
                                            ).save
      end
      @transaction.update_attributes(:status=>"cancelled")
      redirect_to transactions_path, :notice=>"Transaction Cancelled"
    else
      redirect_to transactions_path, :alert=>"No Such Transaction available"
    end
  end
  
  def send_money
    @current_tab = "send_money"
    @balances = current_user.account.account_balances.order("id asc")
    @transaction = Transaction.new
  end
  
  def check_funds(kaenko_currency,transfer_amount)
    @payment_methods = Array.new()
    currency_account_balance = current_user.account.account_balances.where(
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
      return @payment_methods
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
      
      @other_balances = current_user.account.account_balances.where(
                                                    "kaenko_currency_id != ? and balance > 0", 
                                                     kaenko_currency.id).order("id asc")
      @other_balances.each do |other_balance|
        @payment_method = Hash.new
      
        converted_amount = converted_currency(other_balance.balance, 
                                              other_balance.kaenko_currency.unit, 
                                              @transfer_currency_unit)
        
        if converted_amount >= @remaining_amount
          converted_amount = converted_currency(@remaining_amount, 
                                                @transfer_currency_unit, 
                                                other_balance.kaenko_currency.unit)
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
        @error =  "You dont have sufficient funds."
      else
        return @payment_methods
      end
    end
  end
  
  def review_send_money
    @error = ""
    @kaenko_currency = KaenkoCurrency.where(:id=>params[:transaction][:kaenko_currency]).first
    if !@kaenko_currency.present?
      @error = "Invalid Currency"
    end
    
    if params[:transaction].present? and params[:transaction][:transaction_to].present?
      if @kaenko_user.present? and @kaenko_user.account_id == current_user.account_id
        @error = "Can't send money to your own account"
      end
      
      if @error.blank?
        @payment_methods = check_funds(@kaenko_currency, params[:transaction][:amount].to_f)
        @transfer_amount = params[:transaction][:amount].to_f
        @transaction_to_email = (@kaenko_user.present?) ? @kaenko_user.email : params[:transaction][:transaction_to]
        @transaction_to_account = (@kaenko_user.present? and @kaenko_user.account.present?) ? @kaenko_user.account.id : 0
        @transaction = Transaction.new(:to_account_id=>@transaction_to_account, 
                                       :transaction_to=>@transaction_to_email,
                                       :amount=>params[:transaction][:amount].to_f, 
                                       :kaenko_currency_id=>@transfer_currency
                                      )
      else
         @error = @error
      end
    else
      if params[:transaction].present? and params[:transaction][:circle].present?
        circle = Circle.where("id = ?",params[:transaction][:circle])
        if circle.present? and circle.first.present?
          @kaenko_users = circle.first.users
          if !@kaenko_users.present?
            @error = "No connection added in the circle"
          end
        else
          @error = "Circle does not exists"
        end

        
        if @error.blank?
          @transaction_type = "multiple"
          @payment_methods = check_funds(@kaenko_currency, params[:transaction][:amount].to_f * @kaenko_users.count)
          @transfer_amount = params[:transaction][:amount].to_f
          @transaction_to_email = (@kaenko_user.present?) ? @kaenko_user.email : params[:transaction][:transaction_to]
          @transaction_to_account = (@kaenko_user.present? and @kaenko_user.account.present?) ? @kaenko_user.account.id : 0
          @transaction = Transaction.new(:to_account_id=>@transaction_to_account, 
                                         :transaction_to=>@transaction_to_email,
                                         :amount=>params[:transaction][:amount].to_f, 
                                         :kaenko_currency_id=>@transfer_currency
                                        )
         
        else
           @error = @error
        end
      else
          @error = "No connection added in the circle."
      end
    end
  end
  
  def create

    @payment_methods = Array.new()
    @error = ""
    @notice = ""
    @kaenko_currency = KaenkoCurrency.where(:unit=>params[:kaenko_currency]).first
    if !@kaenko_currency.present?
      @error = "Invalid Currency"
    end
    
    @kaenko_user = User.where(:email=>params[:transaction_to]).first
    
    if @kaenko_user.present? and @kaenko_user.account_id == current_user.account_id
      @error = "Can't send money to your own account"
    end
    
    if @error.blank?
		  @payment_methods = check_funds(@kaenko_currency, params[:amount].to_f)
      
      @payment_methods.each do |payment_method|
        account_balance = current_user.account.account_balances
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
      @transaction.status = (@kaenko_user.present?) ? "completed" : "pending"
      @transaction.user_id = current_user.id      
      @transaction.transaction_to = (@kaenko_user.present?) ? @kaenko_user.email : params[:transaction_to]
      @transaction.to_account_id = (@kaenko_user.present? and @kaenko_user.account.present?) ? @kaenko_user.account.id : 0 
      @transaction.kaenko_currency_id = @kaenko_currency.id
      @transaction.amount = params[:amount]
      
      if @transaction.save
        if @kaenko_user.present?
          @reciever_account_balance = @kaenko_user.account
                                        .account_balances
                                        .where("kaenko_currency_id = ?", @kaenko_currency.id).first
          if @reciever_account_balance.present?
            @reciever_account_balance.update_attributes(
                                :balance=>@reciever_account_balance.balance+@transaction.amount.to_f
                                )
          else
            @reciever_account_balance = @kaenko_user.account.account_balances.new(
                                          :kaenko_currency_id=>@kaenko_currency.id, 
                                          :balance=>@transaction.amount.to_f).save
          end
          @notice = "Transaction Successfull"
        else
          @notice = "Transaction Successfull and Pending for receiver's acceptance"
        end
      else
        @payment_methods.each do |payment_method|
          account_balance = current_user.account
                                        .account_balances.where("id = ?",payment_method["balance_id"])
          if account_balance.present?
            account_balance = account_balance.first
            account_balance.update_attributes(
                      :balance=>account_balance.balance+payment_method["balance_used"].to_f
                      )
          end
        end
        @error =  "Unable to Process transaction. Please try after some time"
      end
    else
      @error = @error
    end
  end
  
  def request_money
  end

  def circle_transaction
    @payment_methods = Array.new()
    @error = ""
    @notice = ""
    @success_transaction = []
    @rejected_transaction = []
    @kaenko_currency = KaenkoCurrency.where(:unit=>params[:kaenko_currency]).first
    if !@kaenko_currency.present?
      @error = "Invalid Currency"
    end
    if params[:transaction_to].present? and params[:transaction_to].size > 0
      params[:transaction_to].each do |user_email|
        @kaenko_user = User.where(:email=>user_email).first
        
        if @kaenko_user.present? and @kaenko_user.account_id == current_user.account_id
          @error = "Can't send money to your own account"
        end
        
        if @error.blank?
          @payment_methods = check_funds(@kaenko_currency, params[:amount].to_f)
          
          @payment_methods.each do |payment_method|
            account_balance = current_user.account.account_balances
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
          @transaction.status = (@kaenko_user.present?) ? "completed" : "pending"
          @transaction.user_id = current_user.id      
          @transaction.transaction_to = @kaenko_user.email 
          @transaction.to_account_id = (@kaenko_user.present? and @kaenko_user.account.present?) ? @kaenko_user.account.id : 0 
          @transaction.kaenko_currency_id = @kaenko_currency.id
          @transaction.amount = params[:amount]
          
          if @transaction.save
            if @kaenko_user.present?
              @reciever_account_balance = @kaenko_user.account
                                            .account_balances
                                            .where("kaenko_currency_id = ?", @kaenko_currency.id).first
              if @reciever_account_balance.present?
                @reciever_account_balance.update_attributes(
                                    :balance=>@reciever_account_balance.balance+@transaction.amount.to_f
                                    )
              else
                @reciever_account_balance = @kaenko_user.account.account_balances.new(
                                              :kaenko_currency_id=>@kaenko_currency.id, 
                                              :balance=>@transaction.amount.to_f).save
              end
              @success_transaction << user_email
            else
              @rejected_transaction << user_email
            end
          else
            @payment_methods.each do |payment_method|
              account_balance = current_user.account
                                            .account_balances.where("id = ?",payment_method["balance_id"])
              if account_balance.present?
                account_balance = account_balance.first
                account_balance.update_attributes(
                          :balance=>account_balance.balance+payment_method["balance_used"].to_f
                          )
              end
            end
            @error =  "Unable to Process transaction. Please try after some time"
          end
        else
          @error = @error
        end
      end
    else
      @error = "Your circle users are not selected."
    end
  end

  def popup_i_withdraw
  end

  def popup_i_addfund
  end

  def popup_i_payment
  end

  def refund
  end

  def issue_refund
  end


  #=========== Refund money from transaction==============
  def create_issue_refund
    @error = ""
    if params[:refund_amount].present?
      if params[:refund_amount].to_d > 0.0 && params[:refund_amount].to_d <= @trans.amount
        @refund_trans = Transaction.new(
                          amount: params[:refund_amount].to_d, 
                          transaction_type: "Payment",
                          status: "Refunded",
                          from_account_id: current_user.account.id,
                          to_account_id: @trans.from_account.id,
                          transaction_from: "User",
                          transaction_to: "User",
                          kaenko_currency_id: @trans.kaenko_currency_id,
                          status: "Completed" , 
                          user_id: current_user.id,
                          transaction_from_id: current_user.id,
                          transaction_to_id: @trans.transaction_from_id,
                          parent_id: @trans.id
                          
                          )
        Transaction.transaction do
          if @refund_trans.save
            @account_balance = current_user.account.account_balances.where(
                  "kaenko_currency_id = ?",
                   @trans.kaenko_currency_id
                ).first
            @account_balance.update_attributes(balance: @account_balance.balance - params[:refund_amount].to_d)
            @trans.update_attributes(status: "Refunded")
          end
        end
      else
        @error = "Please enter valid amount."  
      end
     else
      @error = "Please enter amount."
    end
  end
  #========== end refund==========

  private

  def find_transaction
    @trans = Transaction.find(params[:id])
  end
  
  def transaction_params
  	params.require(:transaction).permit(:to_account_id, :transaction_to, 
                                        :kaenko_currency_id, :amount
                                       )
  end
end
