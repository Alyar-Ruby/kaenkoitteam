class SellOnlinesController < ApplicationController
  def dispute_glossary
  	@disputes = Dispute.where("from_account_id = ? or to_account_id = ?", current_user.account.id, 
  	current_user.account.id).order("created_at desc")
  end

  def customer_glossary
  end

  def review_glossary
  end
end
