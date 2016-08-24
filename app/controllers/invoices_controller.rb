class InvoicesController < ApplicationController
	
	def index
    @current_tab = "request"
    currency = params[:currency].present? ? params[:currency] : 0.to_s
    batch_id = params[:batch_id].present? ? params[:batch_id] : 0.to_s
    @transactions = RequestPayment.find_by_sql("select 'request_payment' as type, 
        id, user_id, request_to as email, status, amount, kaenko_currency_id,  created_at from request_payments where user_id=#{current_user.id}
        union all select 'invoice' as type, id, user_id, receipent as email, status, total as amount, kaenko_currency_id,  created_at
        from invoices where user_id=#{current_user.id} order by 8 desc")
	end

	def new
    @current_tab = "request"
		@invoice = current_user.invoices.new
		@invoice_items = @invoice.invoice_items.build(:kaenko_currency_id=>current_user.account.kaenko_currency_id)
	end
	
	def create
    @current_tab = "request"
		@invoice = current_user.invoices.new(invoice_params)
		@invoice.status = "Pending"
		if @invoice.save
      requester = User.where("email = ?",params[:invoice][:receipent])
      if requester.present? and requester.first.present?
        KaenkoNotification.new(:from_user_id=>current_user.id, :to_user_id=>requester.first.id,
         :message=>"sent you an invoice", :url=>invoice_path(@invoice)).save
      end
		else
			render :new
		end
	end

	def show
		@invoice = invoice
	end

	def pay_invoice_payment
		@payment_methods = Array.new()
    @error = ""
    @notice = ""
    @kaenko_currency = invoice.kaenko_currency
    if !@kaenko_currency.present?
      @error = "Invalid Currency"
    end
    @kaenko_user = User.where(:email=> invoice.user.email).first
    
    if @kaenko_user.present? and @kaenko_user.account_id == current_user.account_id
      @error = "Can't send money to your own account"
    end
    
    if @error.blank?
		  @payment_methods = Transaction.check_funds(@kaenko_currency, invoice.total, current_user)
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
        @transaction.transaction_type = "invoice payment"
        @transaction.status = (@kaenko_user.present?) ? "completed" : "pending"
        @transaction.user_id = current_user.id      
        @transaction.transaction_to = (@kaenko_user.present?) ? @kaenko_user.email : invoice.receipent
        @transaction.to_account_id = (@kaenko_user.present? and @kaenko_user.account.present?) ? @kaenko_user.account.id : 0 
        @transaction.kaenko_currency_id = @kaenko_currency.id
        @transaction.amount = invoice.total
        
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
          invoice.update_attributes(:status => "Completed")
          KaenkoNotification.new(:from_user_id=>current_user.id, :to_user_id=>@kaenko_user.id,
         :message=>"Payment received", :url=>dashboard_overview_path).save
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
    @invoice  = Invoice.find(params[:id])
    @invoice.update_attributes(status: "Cancelled")
  end

	private 

	def invoice_params
		params.require(:invoice).permit(:number, :invoice_date, :due_date, :receipent, 
			:terms_conditions, :subtotal, :shipping, :discount, :total, :kaenko_currency_id , 
			invoice_items_attributes:[:item_name, :quantity, :unit_price, :tax_type, 
															:amount, :kaenko_currency_id] )
	end

	def invoice
		@invoice ||= Invoice.where("id = ?  and status = ? and receipent =?" , 
			params[:id], "Pending" , current_user.email).first
	end

end
