class UserMailer < ActionMailer::Base
  default :from => ENV['KAENKO_MAILER_SENDER']
  
  def send_invite(user, email)
		@user = user
		mail(:to => email, :subject => "Invitation for Account Member")
  end
  
  def send_referral (user, email)
  	@user = user
		mail(:to => email, :subject => "Invitation for Referral")
  end

  def send_subuser_activation(user)
  	@user = user
  	mail(:to => @user.email, :subject => "Account activation")
  end
  def subuser_confirmation(user, token)
  	@user = user
  	@token = token
  	mail(:to => @user.email, :subject => "confirmation account")
  end

  def send_request_payment(request_payment)
    @user = request_payment.user
    @request_payment = request_payment
    @email = request_payment.request_to
    exist_user = User.where("email = ?", @email)
    @name =  (exist_user.size > 0) ? (exist_user.first.name) : @email
    @pay_link = request_payment_url(request_payment) 
    if @user.image.present?
      attachments.inline['user_image.png'] = File.read("#{Rails.root}/public#{@user.image_url(:profile)}")
    end
    mail(:to => @email, :subject => "Payment request")
  end

  def send_invoice_request(invoice)
    @user = invoice.user
    @invoice = invoice
    @email = invoice.receipent
    exist_user = User.where("email = ?", @email)
    @name =  (exist_user.size > 0) ? (exist_user.first.name) : @email
    @pay_link = invoice_url(invoice) 
    if @user.image.present?
      attachments.inline['user_image.png'] = File.read("#{Rails.root}/public#{@user.image_url(:profile)}")
    end
    mail(:to => @email, :subject => "Invoice request")
  end

  def send_add_funds(user, trans)
    @user = user
    @email = user.email
    @name = @user.name
    @amount = trans.amount
    @currency = trans.kaenko_currency.unit
    @transaction_id = trans.transaction_id
    if @user.image.present?
      attachments.inline['user_image.png'] = File.read("#{Rails.root}/public#{@user.image_url(:profile)}")
    end
    mail(:to => @email, :subject => "Funds Added")
  end

  def withdraw_fund(user, trans)
    @user = user
    @email = user.email
    @name = @user.name
    @amount = trans.amount
    @currency = trans.kaenko_currency.unit
    @transaction_id = trans.transaction_id
    if @user.image.present?
      attachments.inline['user_image.png'] = File.read("#{Rails.root}/public#{@user.image_url(:profile)}")
    end
    mail(:to => @email, :subject => "Withdraw Fund")
  end

end
