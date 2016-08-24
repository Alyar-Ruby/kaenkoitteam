class RequestPaymentsController < ApplicationController

	def index
		
	end

	def new
    @current_tab = "request"
		@request_payment = current_user.request_payments.new
	end

	def edit

	end

	def show
		@request_payment = request_payment
	end

	def create
		@request_payment = current_user.request_payments.new(request_payment_params)
		if @request_payment.save
      requester = User.where("email = ?",params[:request_payment][:request_to])
      if requester.present? and requester.first.present?
        currency = KaenkoCurrency.where("id = ?",params[:request_payment][:kaenko_currency_id]).first
        amount = currency.symbol.to_s+params[:request_payment][:amount].to_s+" "+currency.unit.upcase.to_s
        KaenkoNotification.new(:from_user_id=>current_user.id, :to_user_id=>requester.first.id, 
          :message=>"request you #{amount}", roleable_type: "RequestPayment" ,  roleable_id: @request_payment.id,
          :url=>request_payment_path(@request_payment)).save
      end
		else
			render :new
		end
	end

	def pay_request

    @payment_methods = Array.new()
    @error = ""
    @notice = ""
    @kaenko_currency = request_payment.kaenko_currency
    if !@kaenko_currency.present?
      @error = "Invalid Currency"
    end
    @kaenko_user = User.where(:email=> request_payment.user.email).first
    
    if @kaenko_user.present? and @kaenko_user.account_id == current_user.account_id
      @error = "Can't send money to your own account"
    end
    
    if @error.blank?
		  @payment_methods = Transaction.check_funds(@kaenko_currency, request_payment.amount, current_user)
      if @payment_methods.size > 0
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
        @transaction.transaction_to = (@kaenko_user.present?) ? @kaenko_user.email : request_payment.request_to
        @transaction.to_account_id = (@kaenko_user.present? and @kaenko_user.account.present?) ? @kaenko_user.account.id : 0 
        @transaction.kaenko_currency_id = @kaenko_currency.id
        @transaction.amount = request_payment.amount
        
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
          request_payment.update_attributes(status: "Completed")
           KaenkoNotification.new(:from_user_id=>current_user.id, :to_user_id=>@kaenko_user.id,
         :message=>"Payment received", :url=>dashboard_overview_path, roleable_type: "RequestPayment" , roleable_id: request_payment.id).save
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
        @error = "You have no sufficient money to transfer funds."
      end
    else
        @error = @error
    end
	end

  def cancel_request
    @request_payment = RequestPayment.find(params[:id])
    @request_payment.update_attributes(status: "Cancelled")
  end

	private 

		def request_payment_params
			params.require(:request_payment).permit(:request_to, :amount, :memo, 
				:kaenko_currency_id, :title )
		end

		def request_payment
			@request_payment ||= RequestPayment.where("id = ? and request_to = ? and status = ?", 
        params[:id], current_user.email, "Pending").first
		end

end
