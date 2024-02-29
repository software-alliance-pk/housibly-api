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

ActiveRecord::Schema.define(version: 2024_02_28_134945) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
    t.index ["record_type", "record_id"], name: "index_active_storage_attachments_on_record_type_and_record_id"
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
    t.index ["blob_id"], name: "index_active_storage_variant_records_on_blob_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "admin_type", default: 1
    t.string "full_name"
    t.string "user_name"
    t.string "phone_number"
    t.datetime "date_of_birth"
    t.boolean "status", default: true
    t.string "location"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.string "type"
    t.bigint "user_id", null: false
    t.bigint "property_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bookmarked_user_id"
    t.index ["bookmarked_user_id"], name: "index_bookmarks_on_bookmarked_user_id"
    t.index ["property_id"], name: "index_bookmarks_on_property_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "card_infos", force: :cascade do |t|
    t.string "card_id"
    t.integer "exp_month"
    t.integer "exp_year"
    t.string "brand"
    t.string "country"
    t.string "fingerprint"
    t.string "last4"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.bigint "user_id", null: false
    t.boolean "is_default", default: false
    t.index ["user_id"], name: "index_card_infos_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.integer "unread_message", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_blocked", default: false
    t.datetime "deleted_at"
    t.integer "block_by"
    t.index ["deleted_at"], name: "index_conversations_on_deleted_at"
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "dream_addresses", force: :cascade do |t|
    t.string "address"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "longitude"
    t.float "latitude"
    t.index ["user_id"], name: "index_dream_addresses_on_user_id"
  end

  create_table "job_lists", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "read_status", default: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "mobile_devices", force: :cascade do |t|
    t.string "mobile_device_token"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mobile_devices_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_id"
    t.string "integer"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.string "title"
    t.integer "conversation_id"
    t.string "event_type"
    t.boolean "seen", default: false
    t.bigint "property_id"
    t.index ["property_id"], name: "index_notifications_on_property_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.string "price"
    t.string "stripe_package_id"
    t.string "stripe_price_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "package_type"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "permalink"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "admin_id", null: false
    t.index ["admin_id"], name: "index_pages_on_admin_id"
    t.index ["permalink"], name: "index_pages_on_permalink"
  end

  create_table "professions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_professions_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "type"
    t.string "title"
    t.float "price"
    t.integer "year_built"
    t.string "address"
    t.integer "unit"
    t.float "lot_frontage"
    t.float "lot_depth"
    t.float "lot_size"
    t.boolean "is_lot_irregular"
    t.text "lot_description"
    t.integer "bath_rooms"
    t.integer "bed_rooms"
    t.string "living_space"
    t.integer "garage_spaces"
    t.string "garage"
    t.string "parking_type"
    t.string "parking_ownership"
    t.string "condo_type"
    t.string "condo_style"
    t.string "driveway"
    t.string "house_type"
    t.string "house_style"
    t.string "exterior", default: [], array: true
    t.string "water"
    t.string "sewer"
    t.string "heat_source", default: [], array: true
    t.string "air_conditioner", default: [], array: true
    t.string "laundry"
    t.string "fireplace", default: [], array: true
    t.boolean "central_vacuum"
    t.string "basement", default: [], array: true
    t.string "pool"
    t.float "property_tax"
    t.integer "tax_year"
    t.string "appliances_and_other_items"
    t.string "locker"
    t.float "condo_fees"
    t.string "balcony"
    t.string "exposure"
    t.string "security"
    t.string "pets_allowed"
    t.string "included_utilities", default: [], array: true
    t.text "property_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "heat_type", default: [], array: true
    t.bigint "user_id", null: false
    t.boolean "is_property_sold"
    t.string "lot_frontage_unit"
    t.string "lot_depth_unit"
    t.string "lot_size_unit"
    t.text "condo_corporation_or_hqa"
    t.string "currency_type"
    t.integer "total_number_of_rooms"
    t.integer "total_parking_spaces"
    t.boolean "is_bookmark", default: false
    t.float "longitude"
    t.float "latitude"
    t.string "zip_code"
    t.string "weight_age"
    t.string "city"
    t.string "country"
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "reportings", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "reported_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_reportings_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id"
    t.text "description"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "support_closer_id"
    t.index ["support_closer_id"], name: "index_reviews_on_support_closer_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.float "length_in_feet"
    t.float "length_in_inch"
    t.float "width_in_feet"
    t.float "width_in_inch"
    t.string "level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "property_id", null: false
    t.index ["property_id"], name: "index_rooms_on_property_id"
  end

  create_table "saved_searches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "search_type"
    t.json "polygon"
    t.json "circle"
    t.string "title"
    t.string "display_address"
    t.string "zip_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_saved_searches_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "user_id"
    t.string "working_days", default: [], array: true
    t.string "starting_time"
    t.string "ending_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "school_pins", force: :cascade do |t|
    t.string "pin_name"
    t.float "longtitude"
    t.float "latitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.string "city"
    t.string "country"
  end

  create_table "searched_addresses", force: :cascade do |t|
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer "csv_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subscription_histories", force: :cascade do |t|
    t.boolean "cancel_by_user"
    t.string "current_period_end"
    t.string "current_period_start"
    t.string "plan_title"
    t.string "interval_count"
    t.string "interval"
    t.string "subscription_title"
    t.string "status"
    t.string "price"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "payment_currency"
    t.string "payment_nature"
    t.index ["user_id"], name: "index_subscription_histories_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.boolean "cancel_by_user"
    t.string "current_period_end"
    t.string "current_period_start"
    t.string "plan_title"
    t.string "interval_count"
    t.string "interval"
    t.string "subscription_title"
    t.string "status"
    t.string "price"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "subscription_id"
    t.string "payment_nature"
    t.string "payment_currency"
    t.string "sub_type"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "support_conversations", force: :cascade do |t|
    t.bigint "support_id"
    t.integer "recipient_id"
    t.integer "sender_id"
    t.integer "conv_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.boolean "available"
    t.integer "un_read"
    t.boolean "read_status", default: false
    t.boolean "online", default: false
    t.index ["deleted_at"], name: "index_support_conversations_on_deleted_at"
    t.index ["support_id"], name: "index_support_conversations_on_support_id"
  end

  create_table "support_messages", force: :cascade do |t|
    t.text "body"
    t.bigint "support_conversation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.integer "sender_id"
    t.boolean "read_status", default: false
    t.index ["support_conversation_id"], name: "index_support_messages_on_support_conversation_id"
  end

  create_table "supports", force: :cascade do |t|
    t.string "ticket_number"
    t.integer "status", default: 0
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.string "property_type"
    t.string "balcony", default: [], array: true
    t.string "security", default: [], array: true
    t.string "laundry", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.string "lot_size_unit"
    t.integer "max_age"
    t.boolean "is_lot_irregular"
    t.boolean "central_vacuum"
    t.string "currency_type"
    t.string "driveway", default: [], array: true
    t.string "water", default: [], array: true
    t.string "sewer", default: [], array: true
    t.string "pool", default: [], array: true
    t.string "exposure", default: [], array: true
    t.string "pets_allowed", default: [], array: true
    t.string "house_style", default: [], array: true
    t.string "house_type", default: [], array: true
    t.string "condo_style", default: [], array: true
    t.string "condo_type", default: [], array: true
    t.string "exterior", default: [], array: true
    t.string "included_utilities", default: [], array: true
    t.string "basement", default: [], array: true
    t.string "heat_source", default: [], array: true
    t.string "heat_type", default: [], array: true
    t.string "air_conditioner", default: [], array: true
    t.string "fireplace", default: [], array: true
    t.json "price"
    t.json "lot_size"
    t.json "lot_depth"
    t.json "lot_frontage"
    t.json "bed_rooms"
    t.json "bath_rooms"
    t.json "garage_spaces"
    t.json "total_number_of_rooms"
    t.json "total_parking_spaces"
    t.string "lot_frontage_unit"
    t.string "lot_depth_unit"
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "user_search_addresses", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "searched_address_id", null: false
    t.index ["searched_address_id"], name: "index_user_search_addresses_on_searched_address_id"
    t.index ["user_id"], name: "index_user_search_addresses_on_user_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.boolean "push_notification", default: true
    t.boolean "inapp_notification", default: true
    t.boolean "email_notification", default: true
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone_number"
    t.text "description"
    t.boolean "licensed_realtor"
    t.boolean "contacted_by_real_estate"
    t.integer "user_type"
    t.integer "profile_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "reset_signup_token"
    t.datetime "reset_signup_token_sent_at"
    t.boolean "is_otp_verified", default: false
    t.boolean "is_confirmed", default: false
    t.string "stripe_customer_id"
    t.string "country_code"
    t.string "country_name"
    t.boolean "active", default: true
    t.string "currency_type"
    t.integer "currency_amount"
    t.string "address"
    t.float "longitude"
    t.float "latitude"
    t.boolean "is_reported", default: false
    t.datetime "last_seen"
    t.string "login_type"
    t.boolean "profile_complete"
    t.float "hourly_rate"
    t.string "apple_user_id"
    t.string "google_user_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "visitors", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "visit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_visitors_on_user_id"
    t.index ["visit_id"], name: "index_visitors_on_visit_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "properties"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "bookmarks", "users", column: "bookmarked_user_id"
  add_foreign_key "card_infos", "users"
  add_foreign_key "dream_addresses", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "mobile_devices", "users"
  add_foreign_key "notifications", "properties"
  add_foreign_key "pages", "admins"
  add_foreign_key "professions", "users"
  add_foreign_key "properties", "users"
  add_foreign_key "reportings", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "rooms", "properties"
  add_foreign_key "saved_searches", "users"
  add_foreign_key "schedules", "users"
  add_foreign_key "subscription_histories", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "support_conversations", "supports"
  add_foreign_key "support_messages", "support_conversations"
  add_foreign_key "supports", "users"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "user_search_addresses", "searched_addresses"
  add_foreign_key "user_search_addresses", "users"
  add_foreign_key "user_settings", "users"
  add_foreign_key "visitors", "users"
end
