module AccountPaymentSettingsHelper
	def bank_status(bank)
		if bank.status == true
		'<span class="label label-success">
      	Verified
      </span>'.html_safe  
     else
      '<a class="btn btn-sm btn-default-border" href="#">Verify Now</a>'.html_safe
#     	'<span class="label label-danger">      	Not Verified      </span>'.html_safe 
     end
	end
  
	def card_status(card)
		if card.status == true
		'<span class="label label-success">
      	Verified
      </span>'.html_safe  
     else
      '<a class="btn btn-sm btn-default-border" href="#">Verify Now</a>'.html_safe
#     	'<span class="label label-danger">      	Not Verified      </span>'.html_safe 
     end
	end
end
