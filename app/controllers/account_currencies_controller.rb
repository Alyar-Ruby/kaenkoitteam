class AccountCurrenciesController < ApplicationController

  def new
    currency_ids = account.account_balances.collect{|c| c.kaenko_currency_id}
    @account_currencies =  (currency_ids.size > 0) ? KaenkoCurrency.where("id not in (?)", currency_ids) : KaenkoCurrency.all
    @account_currency = account.account_balances.new
  end

  def create
    @account_currency = account.account_balances.new(currency_params)
    @account_currency.save
    currency_ids = account.account_balances.collect{|c| c.kaenko_currency_id}
    @account_currencies =  (currency_ids.size > 0) ? KaenkoCurrency.where("id not in (?)", currency_ids) : KaenkoCurrency.all
  end

  def show_currency
    @account_currencies = account.account_balances.order("is_primary desc")
  end

  def remove_currency
    account_balance = AccountBalance.find_by_id(params[:id])
    converted_currency = account_balance.kaenko_currency.unit
    primary_currency = account.account_balances.where("is_primary = ?", true).first
    converted_balance = converted_currency(account_balance.balance, account_balance.kaenko_currency.try(:unit), 
      primary_currency.kaenko_currency.unit)
    total_balance = primary_currency.balance + converted_balance
    if account_balance.destroy
      primary_currency.update_column(:balance, total_balance )
    end
    @account_currencies = account.account_balances.order("is_primary desc")
    currency_ids = account.account_balances.collect{|c| c.kaenko_currency_id}
    @account_currencies =  (currency_ids.size > 0) ? KaenkoCurrency.where("id not in (?)", currency_ids) : KaenkoCurrency.all
  end

  private

  def account
    @account ||= current_user.account
  end

  def currency_params
    params.require(:account_balance).permit(:kaenko_currency_id)
  end

  

end
