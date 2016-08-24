class AdminMailer < ActionMailer::Base
  default :from => ENV['KAENKO_MAILER_SENDER']
  
  def send_premium_request_response(user)
		@user = user
		mail(:to => @user['email'], :subject => "Reponse to your Premium Request") if !@user['email'].blank?	
  end
end
