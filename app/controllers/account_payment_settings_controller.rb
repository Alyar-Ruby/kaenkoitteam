class AccountPaymentSettingsController < ApplicationController
	def index
		@current_tab = "settings"
		@banks = current_user.banks.order("name")
		@cards = current_user.cards.order("name")
	end
end
