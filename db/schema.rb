# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140225151253) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_settings", force: true do |t|
    t.integer  "user_id"
    t.string   "pin",                       limit: 4
    t.integer  "user_security_question_id"
    t.string   "security_question_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", force: true do |t|
    t.string   "account_id",    limit: 10
    t.integer  "user_id"
    t.boolean  "approved",                 default: true
    t.boolean  "premium",                  default: false
    t.boolean  "verified",                 default: false
    t.integer  "roleable_id"
    t.string   "roleable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "businesses", force: true do |t|
    t.string   "country_of_incorporation"
    t.string   "organization_name"
    t.string   "organization_url"
    t.string   "legal_form"
    t.string   "registration_number"
    t.date     "date_of_incorporation"
    t.string   "industry"
    t.string   "country"
    t.string   "state"
    t.text     "address"
    t.string   "postal_code"
    t.string   "city"
    t.integer  "admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "commission"
  end

  create_table "earnings", force: true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.string   "currency"
    t.decimal  "amount"
    t.string   "transaction_type"
    t.decimal  "fee_earned_percent"
    t.decimal  "fee_earned_value"
    t.string   "batch_id"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees_exchanges", force: true do |t|
    t.string   "from_currency"
    t.string   "to_currency"
    t.decimal  "fee_percent"
    t.decimal  "fee_value"
    t.decimal  "our_fee"
    t.decimal  "fx_fee"
    t.string   "provider"
    t.decimal  "limit_pd"
    t.string   "exchange_group"
    t.string   "account_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees_from_tos", force: true do |t|
    t.string   "from_account"
    t.string   "to_account"
    t.string   "mode"
    t.decimal  "fee_percent"
    t.decimal  "fee_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees_redemptions", force: true do |t|
    t.string   "account"
    t.string   "payment_option"
    t.string   "account_type"
    t.decimal  "brute_fee_percent"
    t.decimal  "brute_fee_value"
    t.decimal  "total_fee_percent"
    t.decimal  "total_fee_value"
    t.decimal  "our_margin"
    t.decimal  "limits"
    t.string   "provider"
    t.string   "timings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees_uploads", force: true do |t|
    t.string   "account"
    t.string   "payment_option"
    t.string   "settlement_currencies"
    t.string   "account_type"
    t.decimal  "brute_fee_percent"
    t.decimal  "brute_fee_value"
    t.decimal  "total_fee_percent"
    t.decimal  "total_fee_value"
    t.decimal  "our_margin"
    t.decimal  "limits"
    t.string   "provider"
    t.boolean  "refund"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: true do |t|
    t.string   "email"
    t.integer  "business_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kaenko_settings", force: true do |t|
    t.decimal  "business_commission"
    t.datetime "date_time"
    t.string   "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "currency"
    t.string   "order"
    t.decimal  "amount"
    t.decimal  "fee_percent"
    t.decimal  "fee_value"
    t.string   "batch_id"
    t.string   "status"
    t.text     "note"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payout_currencies", force: true do |t|
    t.integer  "fees_redemption_id"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "premium_requests", force: true do |t|
    t.integer  "user_id"
    t.text     "request"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     limit: 10, default: "pending"
    t.string   "comments"
  end

  create_table "settlement_currencies", force: true do |t|
    t.integer  "fees_upload_id"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", force: true do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "timelines", force: true do |t|
    t.integer  "user_id"
    t.string   "task"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.string   "transaction_from"
    t.string   "transaction_to"
    t.string   "transaction_type"
    t.string   "currency"
    t.string   "fee_payer"
    t.decimal  "amount"
    t.decimal  "fee_percent"
    t.decimal  "fee_value"
    t.string   "batch_id"
    t.string   "status"
    t.text     "note"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_security_questions", force: true do |t|
    t.string "name", null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                              default: "",    null: false
    t.string   "encrypted_password",                 default: "",    null: false
    t.string   "language"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "nationality"
    t.string   "country"
    t.string   "state"
    t.text     "address"
    t.string   "city"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "username"
    t.integer  "roleable_id"
    t.string   "roleable_type"
    t.string   "representative_position",            default: ""
    t.boolean  "approved",                           default: true
    t.boolean  "premium",                            default: false
    t.boolean  "verified",                           default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_id",              limit: 10
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
