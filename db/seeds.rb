
connection = ActiveRecord::Base.connection();

connection.execute("TRUNCATE TABLE user_security_questions RESTART IDENTITY")
connection.execute("TRUNCATE TABLE admins RESTART IDENTITY")
connection.execute("TRUNCATE TABLE kaenko_settings RESTART IDENTITY")
connection.execute("TRUNCATE TABLE accounts RESTART IDENTITY")
connection.execute("TRUNCATE TABLE users RESTART IDENTITY")
connection.execute("TRUNCATE TABLE businesses RESTART IDENTITY")
connection.execute("TRUNCATE TABLE premium_requests RESTART IDENTITY")
connection.execute("TRUNCATE TABLE referrals RESTART IDENTITY")
connection.execute("TRUNCATE TABLE earnings RESTART IDENTITY")
connection.execute("TRUNCATE TABLE fees_redemptions RESTART IDENTITY")
connection.execute("TRUNCATE TABLE payout_currencies RESTART IDENTITY")
connection.execute("TRUNCATE TABLE fees_uploads RESTART IDENTITY")
connection.execute("TRUNCATE TABLE fees_from_tos RESTART IDENTITY")
connection.execute("TRUNCATE TABLE settlement_currencies RESTART IDENTITY")
connection.execute("TRUNCATE TABLE fees_exchanges RESTART IDENTITY")
connection.execute("TRUNCATE TABLE orders RESTART IDENTITY")
connection.execute("TRUNCATE TABLE transactions RESTART IDENTITY")
connection.execute("TRUNCATE TABLE timelines RESTART IDENTITY")
connection.execute("TRUNCATE TABLE kaenko_currencies RESTART IDENTITY")
connection.execute("TRUNCATE TABLE account_balances RESTART IDENTITY")
connection.execute("TRUNCATE TABLE roles RESTART IDENTITY")
connection.execute("TRUNCATE TABLE capabilities RESTART IDENTITY")
connection.execute("TRUNCATE TABLE categories RESTART IDENTITY")

Admin.create(:email => 'admin@admin.com', :password => 'password')

UserSecurityQuestion.create! name: 'What is your favorite movie?'
UserSecurityQuestion.create! name: 'What is your favorite car?'
UserSecurityQuestion.create! name: 'What is your first school?'
UserSecurityQuestion.create! name: 'What is your first vehicle?'


KaenkoSetting.create(:business_commission => '2.9', :date_time => '2014-02-24 10:11:23', :timezone=>'GMT')

KaenkoCurrency.create(:unit=>"USD", :title=>"United States dollar")
KaenkoCurrency.create(:unit=>"AUD", :title=>"Australian dollar")
KaenkoCurrency.create(:unit=>"EUR", :title=>"Euro")
KaenkoCurrency.create(:unit=>"GBP", :title=>"British pound")
KaenkoCurrency.create(:unit=>"HKD", :title=>"Hong Kong dollar")
KaenkoCurrency.create(:unit=>"SGD", :title=>"Singapore dollar")
KaenkoCurrency.create(:unit=>"ARS", :title=>"Argentine peso")
KaenkoCurrency.create(:unit=>"BRL", :title=>"Brazilian real")
KaenkoCurrency.create(:unit=>"BGN", :title=>"Bulgarian lev")
KaenkoCurrency.create(:unit=>"CAD", :title=>"Canadian dollar")
KaenkoCurrency.create(:unit=>"CLP", :title=>"Chilean peso")
KaenkoCurrency.create(:unit=>"CNY", :title=>"Chinese renminbi")
KaenkoCurrency.create(:unit=>"CZK", :title=>"Czech koruna")
KaenkoCurrency.create(:unit=>"DKK", :title=>"Danish krone")
KaenkoCurrency.create(:unit=>"GIP", :title=>"Gibraltar pound")
KaenkoCurrency.create(:unit=>"HUF", :title=>"Hungarian forint")
KaenkoCurrency.create(:unit=>"ISK", :title=>"Icelandic króna")
KaenkoCurrency.create(:unit=>"IDR", :title=>"Indonesian rupiah")
KaenkoCurrency.create(:unit=>"LTL", :title=>"Lithuanian litas")
KaenkoCurrency.create(:unit=>"MYR", :title=>"Malaysian ringgit")
KaenkoCurrency.create(:unit=>"MXN", :title=>"Mexican peso")
KaenkoCurrency.create(:unit=>"NZD", :title=>"New Zealand dollar")
KaenkoCurrency.create(:unit=>"NOK", :title=>"Norwegian krone")
KaenkoCurrency.create(:unit=>"PEN", :title=>"Peruvian nuevo sol")
KaenkoCurrency.create(:unit=>"PHP", :title=>"Philippine peso")
KaenkoCurrency.create(:unit=>"PLN", :title=>"Polish zloty")
KaenkoCurrency.create(:unit=>"RON", :title=>"Romanian leu")
KaenkoCurrency.create(:unit=>"SEK", :title=>"Swedish krona")
KaenkoCurrency.create(:unit=>"THB", :title=>"Thai baht")
KaenkoCurrency.create(:unit=>"TRY", :title=>"Turkish new lira")
KaenkoCurrency.create(:unit=>"ZAR", :title=>"South African rand")

Account.create(:kaenko_currency_id=>1, :account_number=>"858275", :roleable_id=>1, :roleable_type=>"Business", :approved=>true, :premium=>false, :verified=>false, :active=>true) #1
User.create(:email=>"user1@test.com", :password=>"password", :language=>"English", :first_name=>"user1", :last_name=>"last1", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user1", :active=>true, :representative_position=>"tester", :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>1)
Business.create(:country_of_incorporation=>"AE", :organization_name=>"test organization 1", :organization_url=>"http://testorg1.com", :legal_form=>"test1", :registration_number=>"test1", :date_of_incorporation=>"2012-02-04", :category_id=>1, :sub_category_id=>2, :country=>"AE", :state=>"AJ", :address=>"test address 1", :postal_code=>"222222", :city=>"test city 1", :commission=>"2.9")

Account.create(:kaenko_currency_id=>1, :account_number=>"461066", :roleable_id=>2, :roleable_type=>"Business", :approved=>false, :premium=>true, :verified=>false, :active=>true) #2
User.create(:email=>"user2@test.com", :password=>"password", :language=>"English", :first_name=>"user2", :last_name=>"last2", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user2", :active=>false, :representative_position=>"tester", :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>2)
Business.create(:country_of_incorporation=>"AE", :organization_name=>"test organization 2", :organization_url=>"http://testorg2.com", :legal_form=>"test2", :registration_number=>"test2", :date_of_incorporation=>"2012-02-04", :category_id=>1, :sub_category_id=>2, :country=>"AE", :state=>"AJ", :address=>"test address 2", :postal_code=>"222222", :city=>"test city 2")
PremiumRequest.create(:user_id=>2, :account_id=>2, :request=>"I need a Premium Account", :status=>"pending")

Account.create(:kaenko_currency_id=>1, :account_number=>"156018", :roleable_id=>3, :roleable_type=>"Business", :approved=>true, :premium=>false, :verified=>false, :active=>false) #3
User.create(:email=>"user3@test.com", :password=>"password", :language=>"English", :first_name=>"user3", :last_name=>"last3", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user3", :active=>true, :representative_position=>"tester", :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>3)
Business.create(:country_of_incorporation=>"AE", :organization_name=>"test organization 3", :organization_url=>"http://testorg3.com", :legal_form=>"test3", :registration_number=>"test3", :date_of_incorporation=>"2012-02-04", :category_id=>1, :sub_category_id=>2, :country=>"AE", :state=>"AJ", :address=>"test address 3", :postal_code=>"222222", :city=>"test city 3", :commission=>"2.9")

Account.create(:kaenko_currency_id=>1, :account_number=>"705442", :roleable_id=>4, :roleable_type=>"Business", :approved=>false, :premium=>true, :verified=>false, :active=>true) #4
User.create(:email=>"user4@test.com", :password=>"password", :language=>"English", :first_name=>"user4", :last_name=>"last4", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user4", :active=>true, :representative_position=>"tester", :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>4)
Business.create(:country_of_incorporation=>"AE", :organization_name=>"test organization 4", :organization_url=>"http://testorg4.com", :legal_form=>"test4", :registration_number=>"test4", :date_of_incorporation=>"2012-02-04", :category_id=>1, :sub_category_id=>2, :country=>"AE", :state=>"AJ", :address=>"test address 4", :postal_code=>"222222", :city=>"test city 4")
PremiumRequest.create(:user_id=>4, :account_id=>4, :request=>"I need a Premium Account", :status=>"rejected", :comments=>"Request rejected")

Account.create(:kaenko_currency_id=>1, :account_number=>"356541", :roleable_id=>0, :roleable_type=>"Personal", :approved=>true, :premium=>false, :verified=>false, :active=>true) #5
User.create(:email=>"user5@test.com", :password=>"password", :language=>"English", :first_name=>"user5", :last_name=>"last5", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user5", :active=>true, :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>5)

Account.create(:kaenko_currency_id=>1, :account_number=>"540725", :roleable_id=>5, :roleable_type=>"Business", :approved=>true, :premium=>false, :verified=>true, :active=>true) #6
User.create(:email=>"user6@test.com", :password=>"password", :language=>"English", :first_name=>"user6", :last_name=>"last6", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user6", :active=>true, :representative_position=>"tester", :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>6)
Business.create(:country_of_incorporation=>"AE", :organization_name=>"test organization 5", :organization_url=>"http://testorg5.com", :legal_form=>"test5", :registration_number=>"test5", :date_of_incorporation=>"2012-02-04", :category_id=>1, :sub_category_id=>2, :country=>"AE", :state=>"AJ", :address=>"test address 5", :postal_code=>"222222", :city=>"test city 5", :commission=>"2.9")

Account.create(:kaenko_currency_id=>1, :account_number=>"788712", :roleable_id=>0, :roleable_type=>"Personal", :approved=>true, :premium=>false, :verified=>false, :active=>true) #7
User.create(:email=>"user7@test.com", :password=>"password", :language=>"English", :first_name=>"user7", :last_name=>"last7", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user7", :active=>true, :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>7)

Account.create(:kaenko_currency_id=>1, :account_number=>"130713", :roleable_id=>6, :roleable_type=>"Business", :approved=>true, :premium=>true, :verified=>false, :active=>true) #8
User.create(:email=>"user8@test.com", :password=>"password", :language=>"English", :first_name=>"user8", :last_name=>"last8", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user8", :active=>true, :representative_position=>"tester", :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>8)
User.create(:email=>"user9@test.com", :password=>"password", :language=>"English", :first_name=>"user9", :last_name=>"last9", :gender=>"male", :date_of_birth=>"1996-02-19", :nationality=>"AZ", :country=>"AZ", :state=>"CUL", :address=>"test address", :city=>"test city", :postal_code=>"111111", :phone=>"9999999999", :username=>"user9", :active=>true, :representative_position=>"tester", :confirmed_at=>"2014-02-25 12:31:00.565824", :account_id=>8, :account_admin=>false)
Business.create(:country_of_incorporation=>"AE", :organization_name=>"test organization 6", :organization_url=>"http://testorg6.com", :legal_form=>"test6", :registration_number=>"test6", :date_of_incorporation=>"2012-02-04", :category_id=>1, :sub_category_id=>2, :country=>"AE", :state=>"AJ", :address=>"test address 6", :postal_code=>"222222", :city=>"test city 6", :commission=>"4")
PremiumRequest.create(:user_id=>8, :account_id=>8, :request=>"I need a Premium Account", :status=>"approved", :comments=>"Request Approved")

Invite.create(:email=>'user9@test.com', :account_id=>8)

Referral.create(account_type: "World", levels: 3, commission: 10, commission_level: {"1" => "5", "2" => "3", "3" => "2"})
Referral.create(account_type: "Business", levels: 3, commission: 10, commission_level: {"1" => "5", "2" => "3", "3" => "2"})
Referral.create(account_type: "Premier", levels: 4, commission: 12, commission_level: {"1" => "6", "2" => "3", "3" => "2", "4" => "1"})

Earning.create(kaenko_currency_id: 1, amount: 29, transaction_type: "USD/EUR Exchange", fee_earned_percent: 2.99, fee_earned_value: 0.25, batch_id: 3538583, note: "")
Earning.create(kaenko_currency_id: 2, amount: 49, transaction_type: "AUD/RMB Exchange", fee_earned_percent: 3.5, fee_earned_value: 0.25, batch_id: 3538583, note: "")
Earning.create(kaenko_currency_id: 4, amount: 22.22, transaction_type: "FROM/TO", fee_earned_percent: 2.2, fee_earned_value: 0.22, batch_id: 35377583, note: "Premier	Referrals	fee	already deducted(12%)")


FeesRedemption.create(account: "PERSONAL DEBIT CARD AND CREDIT CARD (HK Merchant Account)", payment_option: "VISA", account_type: "HK", brute_fee_percent: nil, brute_fee_value: 2.5, total_fee_percent: nil, total_fee_value: 5, our_margin: 50, limits: 10000, provider: "WP", timings: "2/3 days")
PayoutCurrency.create(:kaenko_currency_id=>4, :fees_redemption_id=>FeesRedemption.last.id)

FeesRedemption.create(account: "PERSONAL DEBIT CARD AND CREDIT CARD (HK Merchant Account)", payment_option: "MASTER CARD", account_type: "HK", brute_fee_percent: 2.1, brute_fee_value: 0.17, total_fee_percent: 2.42, total_fee_value: 0.2, our_margin: 15, limits: nil, provider: "WP", timings: nil)
PayoutCurrency.create(:kaenko_currency_id=>1, :fees_redemption_id=>FeesRedemption.last.id)


FeesRedemption.create(account: "COMMERCIAL DEBIT AND CREDIT CARD (HK Merchant Account)", payment_option: "VISA", account_type: "HK", brute_fee_percent: 2.4, brute_fee_value: 0.17, total_fee_percent: 2.76, total_fee_value: 0.2, our_margin: 15, limits: nil, provider: "WP", timings: nil)
PayoutCurrency.create(:kaenko_currency_id=>4, :fees_redemption_id=>FeesRedemption.last.id)

FeesRedemption.create(account: "COMMERCIAL DEBIT AND CREDIT CARD (HK Merchant Account)", payment_option: "MASTER CARD", account_type: "HK", brute_fee_percent: 2.4, brute_fee_value: 0.17, total_fee_percent: 2.76, total_fee_value: 0.2, our_margin: 15, limits: nil, provider: "WP", timings: nil)
PayoutCurrency.create(:kaenko_currency_id=>5, :fees_redemption_id=>FeesRedemption.last.id)


FeesUpload.create(account: "PERSONAL DEBIT CARD AND CREDIT CARD (HK Merchant Account)", payment_option: "VISA", account_type: "HK", brute_fee_percent: 2.1, brute_fee_value: 0.17, total_fee_percent: 2.42, total_fee_value: 0.2, our_margin: 15,  provider: "WP", refund: 1)
SettlementCurrency.create(:kaenko_currency_id=>5, :fees_upload_id=>FeesUpload.last.id)

FeesUpload.create(account: "PERSONAL DEBIT CARD AND CREDIT CARD (HK Merchant Account)", payment_option: "MASTER CARD", account_type: "HK", brute_fee_percent: 2.1, brute_fee_value: 0.17, total_fee_percent: 2.42, total_fee_value: 0.2, our_margin: 15,  provider: "WP", refund: 1)
SettlementCurrency.create(:kaenko_currency_id=>4, :fees_upload_id=>FeesUpload.last.id)

FeesUpload.create(account: "COMMERCIAL DEBIT CARD AND CREDIT CARD (HK Merchant Account)", payment_option: "VISA", account_type: "HK", brute_fee_percent: 2.4, brute_fee_value: 0.17, total_fee_percent: 2.76, total_fee_value: 0.2, our_margin: 15,  provider: "WP", refund: 1)
SettlementCurrency.create(:kaenko_currency_id=>4, :fees_upload_id=>FeesUpload.last.id)

FeesUpload.create(account: "COMMERCIAL DEBIT CARD AND CREDIT CARD (HK Merchant Account)", payment_option: "MASTER CARD", account_type: "HK", brute_fee_percent: 2.4, brute_fee_value: 0.17, total_fee_percent: 2.76, total_fee_value: 0.2, our_margin: 15,  provider: "WP", refund: 1)
SettlementCurrency.create(:kaenko_currency_id=>1, :fees_upload_id=>FeesUpload.last.id)

FeesFromTo.create(from_account: "World", to_account: "World", mode: "ALL 3", fee_percent: nil, fee_value: nil )
FeesFromTo.create(from_account: "Business", to_account: "Business", mode: "ALL 3", fee_percent: nil, fee_value: nil )
FeesFromTo.create(from_account: "Premier", to_account: "Premier", mode: "ALL 3", fee_percent: nil, fee_value: nil )


FeesExchange.create(from_currency_id: 1, to_currency_id: 3, fee_percent: 2.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: 10000, 
	exchange_group: "A	exchanges	between	2	S", account_type: "World")

FeesExchange.create(from_currency_id: 1, to_currency_id: 4, fee_percent: 3.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: nil, 
	exchange_group: "A	exchanges	between	2	S", account_type: "World")

FeesExchange.create(from_currency_id: 1, to_currency_id: 12, fee_percent: 1.99, fee_value: 0.50, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: 10000, 
	exchange_group: "A	exchanges	between	2	S", account_type: "World")

FeesExchange.create(from_currency_id: 1, to_currency_id: 29, fee_percent: 4.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: 10000, 
	exchange_group: "B exchanges	between	S/E", account_type: "Business")


FeesExchange.create(from_currency_id: 1, to_currency_id: 6, fee_percent: 3.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: nil, 
	exchange_group: "B exchanges	betwee	n	S/E", account_type: "Business")

FeesExchange.create(from_currency_id: 1, to_currency_id: 5, fee_percent: 2.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: 10000, 
	exchange_group: "B exchanges	between	S/E", account_type: "Business")


FeesExchange.create(from_currency_id: 1, to_currency_id: 3, fee_percent: 4.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: 10000, 
	exchange_group: "C exchanges	between	2/E", account_type: "Premier")

FeesExchange.create(from_currency_id: 1, to_currency_id: 21, fee_percent: 2.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: nil, 
	exchange_group: "C exchanges	between	2/E", account_type: "Premier")

FeesExchange.create(from_currency_id: 1, to_currency_id: 25, fee_percent: 3.99, fee_value: 0.25, our_fee: 10.00, 
	fx_fee: 20.00, provider: "OZFOREX", limit_pd: 2000, 
	exchange_group: "C exchanges	between	2/E", account_type: "Premier")


Order.create(kaenko_currency_id: 1, amount: 30, order: "USD/EUR Exchange", fee_percent: 2.99, 
	fee_value: 0.25, batch_id: 3838383, status: "Pending")

Order.create(kaenko_currency_id: 2, amount: 30, order: "AUD/RMB Exchange", fee_percent: 3.5, 
	fee_value: 0.25, batch_id: 3538583, status: "Pending")

Order.create(kaenko_currency_id: 2, amount: 2900, order: "AUD/RMB Exchange", fee_percent: 3.5, 
	fee_value: 0.25, batch_id: 3838583, status: "Pending" , note: "Group A (s/s)")



Transaction.create(transaction_from: "john01@gmail.com", 
	transaction_to: "linxsls@gmail.com", transaction_type: 
	"Transfer", kaenko_currency_id: 1, amount: 100, fee_payer: "50%", fee_percent: 2.50, fee_value: 0.25, 
	batch_id: 1235533, status: "completed", note: nil)

Transaction.create(transaction_from: "john01@gmail.com", 
	transaction_to: "linxsls@gmail.com", transaction_type: 
	"Transfer", kaenko_currency_id: 1, amount: 100, fee_payer: "50%", fee_percent: 1.25, fee_value: 0.25, 
	batch_id: 1235533, status: "completed", note: nil)

Transaction.create(transaction_from: "chris01@gmail.com", 
	transaction_to: "linxsls@gmail.com", transaction_type: 
	"Transfer", kaenko_currency_id: 1, amount: 100, fee_payer: "50%", fee_percent: 2.75, fee_value: 0.25, 
	batch_id: 1235533, status: "completed", note: nil)


Timeline.create(:user_id=>1, :task=>"this is the first task done by user 1 on kaenko")
Timeline.create(:user_id=>2, :task=>"this is the first task done by user 3 on kaenko")
Timeline.create(:user_id=>3, :task=>"this is the second task done by user 1 on kaenko")
Timeline.create(:user_id=>4, :task=>"this is the fourth task done by user 1 on kaenko")
Timeline.create(:user_id=>5, :task=>"this is the first task done by user 2 on kaenko")
Timeline.create(:user_id=>6, :task=>"this is the second task done by user 2 on kaenko")
Timeline.create(:user_id=>1, :task=>"this is the fifth task done by user 3 on kaenko")
Timeline.create(:user_id=>2, :task=>"this is the third task done by user 2 on kaenko")
Timeline.create(:user_id=>3, :task=>"this is the second task done by user 3 on kaenko")
Timeline.create(:user_id=>4, :task=>"this is the third task done by user 3 on kaenko")
Timeline.create(:user_id=>5, :task=>"this is the fourth task done by user 2 on kaenko")
Timeline.create(:user_id=>6, :task=>"this is the fourth task done by user 3 on kaenko")
Timeline.create(:user_id=>7, :task=>"this is the third task done by user 1 on kaenko")
Timeline.create(:user_id=>8, :task=>"this is the sixth task done by user 3 on kaenko")


AccountBalance.create(:account_id=>1, :balance=>2000, :kaenko_currency_id=>1)
AccountBalance.create(:account_id=>1, :balance=>2000, :kaenko_currency_id=>2)
AccountBalance.create(:account_id=>1, :balance=>2000, :kaenko_currency_id=>3)
AccountBalance.create(:account_id=>1, :balance=>2000, :kaenko_currency_id=>4)
AccountBalance.create(:account_id=>2, :balance=>2000, :kaenko_currency_id=>2)
AccountBalance.create(:account_id=>3, :balance=>2000, :kaenko_currency_id=>3)
AccountBalance.create(:account_id=>4, :balance=>2000, :kaenko_currency_id=>4)
AccountBalance.create(:account_id=>5, :balance=>2000, :kaenko_currency_id=>5)
AccountBalance.create(:account_id=>6, :balance=>2000, :kaenko_currency_id=>6)
AccountBalance.create(:account_id=>7, :balance=>2000, :kaenko_currency_id=>7)
AccountBalance.create(:account_id=>8, :balance=>2000, :kaenko_currency_id=>8)

Role.create(:title => "Add Connections")
Role.create(:title => "Accept Connections")
Role.create(:title => "Join Groups")
Role.create(:title => "Post comments on Groups")
Role.create(:title => "Create Circles")
Role.create(:title => "Edit Circles")
Role.create(:title => "Delete Circles")

Capability.create(:title => "Make Transfers")
Capability.create(:title => "Make Online Payments")
Capability.create(:title => "Create invoices to request payments")
Capability.create(:title => "Exchange Currencies")
Capability.create(:title => "Pay invoices received by email")

c1 = Category.create(:name => "Education")
sub1 = Category.create(:name => "Business and secretarial schools" , :parent_id => c1.id)
sub2 = Category.create(:name => "Child day care services", :parent_id => c1.id)
sub3 = Category.create(:name => "Colleges and universities" , :parent_id => c1.id)

c2 = Category.create(:name => "Baby")
sub1 = Category.create(:name => "Clothing" , :parent_id => c2.id)
sub2 = Category.create(:name => "Furniture", :parent_id => c2.id)
sub3 = Category.create(:name => "Safety and health" , :parent_id => c2.id)












