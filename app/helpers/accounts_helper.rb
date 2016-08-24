module AccountsHelper
  def sec_to_hr_min(seconds)
    hours = seconds / 3600 
    seconds -= hours * 3600 
    minutes = seconds / 60
    ("%.2d" % hours.to_s) +":"+ ("%.2d" % minutes.to_s)
  end
  
  def timezones()
    ActiveSupport::TimeZone.all.map { |zone| [(zone.utc_offset == 0) ? '(UTC) '+zone.name.to_s : (zone.utc_offset < 0) ? '(UTC'+sec_to_hr_min(zone.utc_offset)+') '+zone.name : '(UTC+'+sec_to_hr_min(zone.utc_offset)+') '+zone.name , zone.name]}
    
    #first.utc_offset
    #Timezone::Zone.list.map { |zone| [(zone[:utc_offset] == 0) ? '(UTC) '+zone[:title].to_s : (zone[:utc_offset] < 0) ? '(UTC'+sec_to_hr_min(zone[:offset])+') '+zone[:title] : '(UTC+'+sec_to_hr_min(zone[:offset])+') '+zone[:title] , zone[:title]]}
  end
  
  def primary_currency_balance(account)
    primary_currency = account.kaenko_currency.unit
    primary_currency_balance = 0

    account.account_balances.each do |balance|
      if balance.kaenko_currency_id == account.kaenko_currency_id
        primary_currency_balance = balance.balance + primary_currency_balance
      else
        converted_balance = converted_currency(balance.balance, balance.kaenko_currency.unit, primary_currency)
        primary_currency_balance = converted_balance + primary_currency_balance
      end
    end
    primary_currency_balance
  end

  def main_balance(account)
    main_balance = account.account_balances.where(kaenko_currency_id: account.kaenko_currency_id).first
    bal = 0
    if main_balance.present?
      bal = number_with_precision(main_balance.balance, :precision => 2 || 0)
    else
      bal = number_with_precision(bal, :precision => 2 || 0)
    end
    "#{bal} #{account.kaenko_currency.unit}"
  end
end
