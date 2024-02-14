# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_14_075706) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_accounts_on_created_by_id"
    t.index ["name"], name: "index_accounts_on_name", unique: true
  end

  create_table "alerts", force: :cascade do |t|
    t.bigint "twilio_account_id", null: false
    t.bigint "call_id"
    t.string "sid"
    t.string "resource_sid"
    t.text "message"
    t.string "request_url"
    t.string "request_method"
    t.string "error_code"
    t.datetime "twilio_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["call_id"], name: "index_alerts_on_call_id"
    t.index ["twilio_account_id"], name: "index_alerts_on_twilio_account_id"
  end

  create_table "apps", force: :cascade do |t|
    t.bigint "twilio_account_id", null: false
    t.string "name"
    t.string "sid"
    t.datetime "last_synced", precision: nil
    t.datetime "twilio_created_at", precision: nil
    t.datetime "twilio_updated_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twilio_account_id"], name: "index_apps_on_twilio_account_id"
  end

  create_table "calls", force: :cascade do |t|
    t.bigint "twilio_account_id", null: false
    t.bigint "from_number_id"
    t.bigint "to_number_id"
    t.string "from_phone"
    t.string "to_phone"
    t.string "status"
    t.string "direction"
    t.integer "duration"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer "queue_time"
    t.string "sid"
    t.string "parent_sid"
    t.string "account_sid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "from_app_id"
    t.bigint "to_app_id"
    t.bigint "conference_id"
    t.datetime "twilio_date_created"
    t.datetime "twilio_date_updated"
    t.datetime "root_call_created_at"
    t.index ["conference_id"], name: "index_calls_on_conference_id"
    t.index ["duration"], name: "index_calls_on_duration"
    t.index ["from_app_id"], name: "index_calls_on_from_app_id"
    t.index ["from_number_id"], name: "index_calls_on_from_number_id"
    t.index ["from_phone"], name: "index_calls_on_from_phone_gin_trgm_ops", opclass: :gin_trgm_ops, using: :gin
    t.index ["to_app_id"], name: "index_calls_on_to_app_id"
    t.index ["to_number_id"], name: "index_calls_on_to_number_id"
    t.index ["to_phone"], name: "index_calls_on_to_phone_gin_trgm_ops", opclass: :gin_trgm_ops, using: :gin
    t.index ["twilio_account_id", "sid"], name: "index_calls_on_twilio_account_id_and_sid", unique: true
    t.index ["twilio_account_id"], name: "index_calls_on_twilio_account_id"
  end

  create_table "conferences", force: :cascade do |t|
    t.string "sid"
    t.string "friendly_name"
    t.bigint "twilio_account_id", null: false
    t.string "account_sid"
    t.datetime "twilio_date_created"
    t.datetime "twilio_date_updated"
    t.string "status"
    t.string "reason_conference_ended"
    t.string "call_sid_ending_conference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twilio_account_id"], name: "index_conferences_on_twilio_account_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.string "account_sid"
    t.string "sid"
    t.string "friendly_name"
    t.string "chat_service_sid"
    t.string "messaging_service_sid"
    t.string "unique_name"
    t.string "state"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.datetime "date_inactive"
    t.datetime "date_closed"
    t.bigint "twilio_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "twilio_attributes", null: false
    t.jsonb "messages", null: false
    t.integer "messages_count", null: false
    t.string "messages_content"
    t.json "messages_list"
    t.index ["twilio_account_id"], name: "index_conversations_on_twilio_account_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "function_logs", force: :cascade do |t|
    t.bigint "twilio_account_id", null: false
    t.string "service_sid"
    t.string "environment_sid"
    t.string "deployment_sid"
    t.string "function_sid"
    t.string "request_sid"
    t.string "level"
    t.text "message"
    t.datetime "date_created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sid"
    t.string "service_name"
    t.string "environment_name"
    t.string "function_name"
    t.index ["sid"], name: "index_function_logs_on_sid", unique: true
    t.index ["twilio_account_id"], name: "index_function_logs_on_twilio_account_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "user_id"], name: "index_memberships_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_memberships_on_account_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "numbers", force: :cascade do |t|
    t.bigint "twilio_account_id", null: false
    t.string "name"
    t.string "phone"
    t.string "sid"
    t.string "address_sid"
    t.string "bundle_sid"
    t.string "identity_sid"
    t.string "status_url"
    t.string "status_method"
    t.string "voice_url"
    t.string "voice_method"
    t.string "voice_fallback_url"
    t.string "voice_fallback_method"
    t.string "sms_url"
    t.string "sms_method"
    t.string "sms_fallback_url"
    t.string "sms_fallback_method"
    t.datetime "last_synced", precision: nil
    t.datetime "twilio_created_at", precision: nil
    t.datetime "twilio_updated_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_numbers_on_name_gin_trgm_ops", opclass: :gin_trgm_ops, using: :gin
    t.index ["phone"], name: "index_numbers_on_phone_gin_trgm_ops", opclass: :gin_trgm_ops, using: :gin
    t.index ["twilio_account_id", "sid"], name: "index_numbers_on_twilio_account_id_and_sid", unique: true
  end

  create_table "service_environments", force: :cascade do |t|
    t.integer "twilio_account_id", null: false
    t.string "service_sid", null: false
    t.string "service_name", null: false
    t.string "environment_sid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "twilio_accounts", force: :cascade do |t|
    t.string "name"
    t.string "account_sid"
    t.string "api_key"
    t.string "api_key_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.string "region", default: "us1"
    t.string "last_pull_status"
    t.datetime "last_pull_start"
    t.datetime "last_pull_end"
    t.index ["account_id", "account_sid", "region"], name: "index_twilio_accounts_on_account_id_and_account_sid_and_region", unique: true
    t.index ["account_id", "name"], name: "index_twilio_accounts_on_account_id_and_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "superuser", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.bigint "created_by_id"
    t.index ["created_by_id"], name: "index_users_on_created_by_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "users", column: "created_by_id"
  add_foreign_key "alerts", "calls"
  add_foreign_key "alerts", "twilio_accounts"
  add_foreign_key "apps", "twilio_accounts"
  add_foreign_key "calls", "apps", column: "from_app_id"
  add_foreign_key "calls", "apps", column: "to_app_id"
  add_foreign_key "calls", "conferences"
  add_foreign_key "calls", "numbers", column: "from_number_id"
  add_foreign_key "calls", "numbers", column: "to_number_id"
  add_foreign_key "calls", "twilio_accounts"
  add_foreign_key "conferences", "twilio_accounts"
  add_foreign_key "conversations", "twilio_accounts"
  add_foreign_key "function_logs", "twilio_accounts"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "memberships", "users"
  add_foreign_key "numbers", "twilio_accounts"
  add_foreign_key "users", "users", column: "created_by_id"
end
