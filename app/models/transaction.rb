# encoding: utf-8
class Transaction < ActiveRecord::Base

  validates_presence_of :transaction_type
  

  
  belongs_to :kaenko_currency
  belongs_to :user
  belongs_to :from_account, :class_name=>"Account", :foreign_key=>"from_account_id"
  belongs_to :to_account, :class_name=>"Account", :foreign_key=>"to_account_id"
  has_one :dispute
  belongs_to :roleable, polymorphic: true

  
  after_create :add_transaction_id
  
  attr_reader :circle

  def add_transaction_id
    self.transaction_id = self.created_at.to_i.to_s+"-"+self.id.to_s
    self.save
  end

  def self.check_funds(kaenko_currency, transfer_amount, user)
    @payment_methods = Array.new()
    currency_account_balance = user.account.account_balances.where(
                                              :kaenko_currency_id=>kaenko_currency.id
                                            ).first
    @currency_balance = 0
    if currency_account_balance.present?
      @currency_balance = currency_account_balance.balance.to_f
    end
    @transfer_currency = kaenko_currency.id
    @transfer_currency_unit = kaenko_currency.unit
    @check_amount = 0
    @payment_method = Hash.new
    if @currency_balance >= transfer_amount
      
      @payment_method['balance_id'] = currency_account_balance.id
      @payment_method['balance_currency'] = currency_account_balance.kaenko_currency.unit
      @payment_method['balance_used'] = transfer_amount.to_s
      @payment_method['transfer_amount'] = transfer_amount.to_s
      @payment_method['transfer_currency'] = @transfer_currency_unit
      
      @payment_methods << @payment_method
      return @payment_methods
    else
      if @currency_balance > 0
        @check_amount = @check_amount + @currency_balance
        @payment_method['balance_id'] = currency_account_balance.id
        @payment_method['balance_currency'] = currency_account_balance.kaenko_currency.unit
        @payment_method['balance_used'] = @currency_balance.to_s
        @payment_method['transfer_amount'] = @currency_balance.to_s
        @payment_method['transfer_currency'] = @transfer_currency_unit
        
        @payment_methods << @payment_method
      end
      
      @remaining_amount = transfer_amount - @currency_balance
      
      @other_balances = user.account.account_balances.where(
                                                    "kaenko_currency_id != ? and balance > 0", 
                                                     kaenko_currency.id).order("id asc")
      @other_balances.each do |other_balance|
        @payment_method = Hash.new
      
        converted_amount = converted_currency(other_balance.balance, 
                                              other_balance.kaenko_currency.unit, 
                                              @transfer_currency_unit)
        
        if converted_amount >= @remaining_amount
          converted_amount = converted_currency(@remaining_amount, 
                                                @transfer_currency_unit, 
                                                other_balance.kaenko_currency.unit)
          @check_amount = @check_amount + @remaining_amount
          
          @payment_method['balance_id'] = other_balance.id
          @payment_method['balance_currency'] = other_balance.kaenko_currency.unit
          @payment_method['balance_used'] = converted_amount.to_s
          @payment_method['transfer_amount'] = @remaining_amount
          @payment_method['transfer_currency'] = @transfer_currency_unit
          
          @payment_methods << @payment_method
          break
        else
          @remaining_amount = @remaining_amount - converted_amount
          @check_amount = @check_amount + converted_amount
          
          @payment_method['balance_id'] = other_balance.id
          @payment_method['balance_currency'] = other_balance.kaenko_currency.unit
          @payment_method['balance_used'] = other_balance.balance.to_s
          @payment_method['transfer_amount'] = converted_amount
          @payment_method['transfer_currency'] = @transfer_currency_unit
          
          @payment_methods << @payment_method
        end
      end
      if @check_amount < transfer_amount
        @payment_methods = []
      else
        return @payment_methods
      end
    end
  end

  def self.converted_currency(amount, from_currency, to_currency)
    Money.default_bank = Money::Bank::GoogleCurrency.new
    Money.new(amount, from_currency).exchange_to(to_currency).fractional
  end

  def payment_method
    method = ""
    #============{self.roleable.try(:card_number[-4..-1])
    if self.roleable_type == "Card"
      method = "#{self.roleable.try(:card_type)}"
    else
      method = "#{self.roleable.try(:name)}"
    end
    method
  end
end
