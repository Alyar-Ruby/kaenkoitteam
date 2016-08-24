class DisputesController < ApplicationController
  def create
    #raise params.inspect
    @trans = Transaction.find(params[:transaction_id])
    if @trans.present?
      Transaction.transaction do
        amount = (params[:request] == "partial_refund") ? params[:amount] : @trans.amount
        @dispute = Dispute.new(
            must_reply_before: Date.today+5.days,
            user_id: @trans.user.id, 
            from_account_id: @trans.from_account_id,
            to_account_id: @trans.to_account_id,
            transaction_id: @trans.id,
            reason: params[:reason],
            amount: amount,
            kaenko_currency_id: @trans.kaenko_currency_id,
            document: params[:document],
            message: params[:message],
            is_shipment_pay: (params[:shipment] == "yes") ? true : false , 
            is_partial_refund: (params[:request] == "partial_refund") ? true : false
          )
        if @dispute.save!
          #@trans.update_attributes(status: "Refunded")
          #==================== dispute message code ======================#
          @recipients = Account.where(id: @trans.to_account_id).order("id asc").all
          uniq = Digest::MD5.hexdigest(Time.now.to_f.to_s+"_s_"+current_user.id.to_s)
          if @recipients.size > 0
            msg = "Dispute Opened for Transaction:# #{@trans.transaction_id}<br/>" 
            msg = msg + "Total Paid: #{amount}<br/>"
            msg = msg + "Reason: #{@dispute.reason}<br/>"
            msg = msg + "Amount:" "#{(@dispute.is_partial_refund == "partial_refund") ? 'Partial Refund' : 'Full Refund'}<br/>" 
            msg = msg + "Ship Back Item: #{(@dispute.is_shipment_pay == true) ? 'Yes' : 'No'}<br/>"
            msg = msg + "Evidence#{@dispute.document_url}<br/>"
            msg = msg + "#{@dispute.message}<br/>"
            msg = msg + "<a href='/transactions/#{@trans.id}/disputes/#{@dispute.id}/accept_solution' data-remote='true' class='btn btn-primary' data-target = '#modal-window' data-toggle = 'modal'>Accept Solution</a>"
            msg = msg + "  "
            msg = msg + "<a href='/transactions/#{@trans.id}/disputes/#{@dispute.id}/modify_solution' data-remote='true' class='btn btn-danger' data-target = '#modal-window' data-toggle = 'modal'>Modify Solution</a><br>"


            account_list = (@recipients.map(&:id) << current_user.account.id).sort!.join("")
            cnv = Conversation.where("accounts = ?", account_list).first
            @conversation = cnv.present? ? cnv : Conversation.new(title: uniq, accounts: account_list )
            if @conversation.save
              conversation_message = @conversation.conversation_messages.create(
                user_id: current_user.id, account_id: current_user.account.id, message: msg)  
              conversation_user= conversation_message.conversation_users.create(
                    conversation_id: @conversation.id, user_id: current_user.id, account_id: current_user.account.id, archive: false, is_read: true)
                  @recipients.each do |recipient|
                    if conversation_message.save
                      @conversation_user = conversation_message.conversation_users.create(
                        conversation_id: @conversation.id,
                        user_id: "", archive: false, account_id: (recipient.id) )
                    end
                  end
            end
          end
          #========================================================#
        end
      end
    end


  end

  #===========dispute refund =============== #
  def modify_solution
    
    @trans = Transaction.find(params[:transaction_id])
    @dispute = Dispute.find(params[:id])
    @error = ""
    if @trans.to_account_id != current_user.account.id
      @error = "Solution can't be modify."
    end
  end

  def accept_solution

    @trans = Transaction.find(params[:transaction_id])
    @dispute = Dispute.find(params[:id])

    @error = ""
    if @trans.to_account_id == current_user.account.id

      if @dispute.is_shipment_pay == true && @dispute.is_resolved == false
      #========== send accept solutions message=================
        @recipients = Account.where(id: @trans.from_account_id).order("id asc").all
        uniq = Digest::MD5.hexdigest(Time.now.to_f.to_s+"_s_"+current_user.id.to_s)
        if @recipients.size > 0
          @msg = "Solution Accepted for Transaction: # #{@trans.transaction_id}<br>" 
          @msg = @msg + "In order to get the refund you must send me the Track ID and an Evidence that you sent to the correct shipping address<br>"
          @msg = @msg + "Shipping Address<br>"
          @msg = @msg + "Beneficiary: #{@trans.from_account.display_name}<br>"
          @msg = @msg + "#{@trans.from_account.display_address}<br>"
          @msg = @msg + "#{@trans.from_account.display_country_name}<br>"
          account_list = (@recipients.map(&:id) << current_user.account.id).sort!.join("")
          cnv = Conversation.where("accounts = ?", account_list).first
          @conversation = cnv.present? ? cnv : Conversation.new(title: uniq, accounts: account_list )
          if @conversation.save
            @conversation_message = @conversation.conversation_messages.create(
              user_id: current_user.id, account_id: current_user.account.id, message: @msg)  
            conversation_user= @conversation_message.conversation_users.create(
                  conversation_id: @conversation.id, user_id: current_user.id, account_id: current_user.account.id, archive: false, is_read: true)
                @recipients.each do |recipient|
                  if @conversation_message.save
                    @conversation_user = @conversation_message.conversation_users.create(
                      conversation_id: @conversation.id,
                      user_id: "", archive: false, account_id: (recipient.id) )
                  end
                end
          end
        end

       #============== message end ========================#  
        @dispute.update_attributes(is_resolved: true)
      else
        @error = "Solution already accepted."

      end
    else
      @error = "Solution can't be accept from you."
    end

  end

 

  #==============create dispute refund transaction================#
  def modify_dispute_refund

   @trans = Transaction.find(params[:transaction_id])
   @dispute = Dispute.find(params[:id])
   @error = ""
   if @trans.status != "Refunded" && @dispute.is_resolved == false
    if (params[:refund_amount].to_d > 0.0) && (params[:refund_amount].to_d <= @trans.amount)
      #======================== transaction refund ==========================
      Transaction.transaction do
        @dispute.update_attributes(
          is_shipment_pay:(params[:item_back] == "true") ? true : false, 
          amount: params[:refund_amount],
          document: params[:document],
          is_resolved: true
          )
        @to_account_balance = @trans.to_account.account_balances.where(
                    "kaenko_currency_id = ?",
                     @trans.kaenko_currency_id
                  ).first
        @to_account_balance.update_attributes(balance: @to_account_balance.balance - params[:refund_amount].to_d)

        @from_account_balance = @trans.from_account.account_balances.where(
                    "kaenko_currency_id = ?",
                     @trans.kaenko_currency_id
                  ).first
        @from_account_balance.update_attributes(balance: @from_account_balance.balance + params[:refund_amount].to_d)

        @new_trans = Transaction.new(
                            amount: params[:refund_amount].to_d, 
                            transaction_type: "Payment",
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
        @new_trans.save
        @trans.update_attributes(status: "Refunded")
        #================once refund send message =========================

        @recipients = Account.where(id: @trans.from_account_id).order("id asc").all
        uniq = Digest::MD5.hexdigest(Time.now.to_f.to_s+"_s_"+current_user.id.to_s)
        if @recipients.size > 0
          @msg = "Solution Accepted for Transaction ID: # #{@trans.transaction_id}<br>" 
          @msg = @msg + "Amount Refunded: #{@dispute.amount} #{@dispute.kaenko_currency.unit}<br>"
          @msg = @msg + "Dispute closed"
          
          account_list = (@recipients.map(&:id) << current_user.account.id).sort!.join("")
          cnv = Conversation.where("accounts = ?", account_list).first
          @conversation = cnv.present? ? cnv : Conversation.new(title: uniq, accounts: account_list )
          if @conversation.save
            @conversation_message = @conversation.conversation_messages.create(
              user_id: current_user.id, account_id: current_user.account.id, message: @msg)  
            conversation_user= @conversation_message.conversation_users.create(
                  conversation_id: @conversation.id, user_id: current_user.id, account_id: current_user.account.id, archive: false, is_read: true)
                @recipients.each do |recipient|
                  if @conversation_message.save
                    @conversation_user = @conversation_message.conversation_users.create(
                      conversation_id: @conversation.id,
                      user_id: "", archive: false, account_id: (recipient.id) )
                  end
                end
          end
        end
        #======================= end message =========================
        end
      else
        @error = "Please enter valid amount."   
      end
    else
      @error = "Sorry!! Dispute is already closed"

    end#=== check status end 
  end

  def accept_dispute_refund
    @trans = Transaction.find(params[:transaction_id])
    @dispute = Dispute.find(params[:id])
    if @dispute.is_resolved == false && @trans.to_account_id == current_user.account.id
      Transaction.transaction do
        @to_account_balance = @trans.to_account.account_balances.where(
                    "kaenko_currency_id = ?",
                     @trans.kaenko_currency_id
                  ).first
        @to_account_balance.update_attributes(balance: @to_account_balance.balance - @dispute.amount)

        @from_account_balance = @trans.from_account.account_balances.where(
                    "kaenko_currency_id = ?",
                     @trans.kaenko_currency_id
                  ).first
        @from_account_balance.update_attributes(balance: @from_account_balance.balance + @dispute.amount)
        @new_trans = Transaction.new(
                              amount: @dispute.amount, 
                              transaction_type: "Payment",
                              from_account_id: current_user.account.id,
                              to_account_id: @trans.from_account.id,
                              status: "Completed",
                              transaction_from: "User",
                              transaction_to: "User",
                              kaenko_currency_id: @trans.kaenko_currency_id,
                              user_id: current_user.id,
                              transaction_from_id: current_user.id,
                              transaction_to_id: @trans.transaction_from_id,
                              parent_id: @trans.id
                        )
          @new_trans.save
        @dispute.update_attributes(is_resolved: true)
        @trans.update_attributes(status: "Refunded")
        #================once refund send message =========================

        @recipients = Account.where(id: @trans.from_account_id).order("id asc").all
        uniq = Digest::MD5.hexdigest(Time.now.to_f.to_s+"_s_"+current_user.id.to_s)
        if @recipients.size > 0
          @msg = "Solution Accpted for Transaction ID: # #{@trans.transaction_id}<br>" 
          @msg = @msg + "Amount Refunded: #{@dispute.amount} #{@dispute.kaenko_currency.unit}"
          @msg = @msg + "Dispute closed"
          
          account_list = (@recipients.map(&:id) << current_user.account.id).sort!.join("")
          cnv = Conversation.where("accounts = ?", account_list).first
          @conversation = cnv.present? ? cnv : Conversation.new(title: uniq, accounts: account_list )
          if @conversation.save
            @conversation_message = @conversation.conversation_messages.create(
              user_id: current_user.id, account_id: current_user.account.id, message: @msg)  
            conversation_user= @conversation_message.conversation_users.create(
                  conversation_id: @conversation.id, user_id: current_user.id, account_id: current_user.account.id, archive: false, is_read: true)
                @recipients.each do |recipient|
                  if @conversation_message.save
                    @conversation_user = @conversation_message.conversation_users.create(
                      conversation_id: @conversation.id,
                      user_id: "", archive: false, account_id: (recipient.id) )
                  end
                end
          end
        end

        #======================= end message =========================
      end
    else
      @error = "Solution can't accept"
    end

  end

end
