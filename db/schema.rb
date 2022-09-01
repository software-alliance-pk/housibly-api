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

ActiveRecord::Schema.define(version: 2022_09_01_075153) do

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
    t.integer "user_id"
    t.integer "property_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "unread_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "dream_addresses", force: :cascade do |t|
    t.string "location"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_dream_addresses_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_id"
    t.string "integer"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "permalink"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "bath_rooms"
    t.string "bed_rooms"
    t.string "living_space"
    t.string "garage_spaces"
    t.string "garage"
    t.string "parking_type"
    t.string "parking_ownership"
    t.string "condo_type"
    t.string "condo_style"
    t.string "driveway"
    t.string "house_type"
    t.string "house_style"
    t.string "exterior"
    t.string "water"
    t.string "sewer"
    t.string "heat_source"
    t.string "air_conditioner"
    t.string "laundry"
    t.string "fireplace"
    t.string "central_vacuum"
    t.string "basement"
    t.string "pool"
    t.integer "property_tax"
    t.integer "tax_year"
    t.string "appliances_and_other_items"
    t.string "locker"
    t.float "condo_fees"
    t.string "balcony"
    t.string "exposure"
    t.string "security"
    t.string "pets_allowed"
    t.string "included_utilities"
    t.text "property_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "heat_type"
    t.bigint "user_id", null: false
    t.boolean "is_property_sold"
    t.float "lot_frontage_unit"
    t.float "lot_depth_unit"
    t.float "lot_size_unit"
    t.text "condo_corporation_or_hqa"
    t.string "currency_type"
    t.integer "total_number_of_rooms"
    t.integer "total_parking_spaces"
    t.boolean "is_bookmark", default: false
    t.index ["user_id"], name: "index_properties_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id"
    t.text "description"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "support_closer_id"
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
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "user_id"
    t.string "working_days"
    t.datetime "starting_time"
    t.datetime "ending_time"
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
  end

  create_table "settings", force: :cascade do |t|
    t.integer "csv_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "support_conversations", force: :cascade do |t|
    t.bigint "support_id"
    t.integer "recipient_id"
    t.integer "sender_id"
    t.integer "conv_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["support_id"], name: "index_support_conversations_on_support_id"
  end

  create_table "support_messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "support_conversation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["support_conversation_id"], name: "index_support_messages_on_support_conversation_id"
    t.index ["user_id"], name: "index_support_messages_on_user_id"
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
    t.decimal "min_price"
    t.decimal "max_price"
    t.string "min_bedrooms"
    t.string "max_bedrooms"
    t.string "min_bathrooms"
    t.string "max_bathrooms"
    t.string "property_style"
    t.string "min_lot_frontage"
    t.integer "min_lot_size"
    t.integer "max_lot_size"
    t.integer "min_living_space"
    t.integer "max_living_space"
    t.string "parking_spot"
    t.string "garbage_spot"
    t.string "max_age"
    t.string "balcony"
    t.string "security"
    t.string "laundry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.string "price_unit"
    t.string "living_space_unit"
    t.string "lot_size_unit"
    t.string "property_types"
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
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
    t.boolean "is_blocked", default: false
  end

  create_table "visitors", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "visit_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_visitors_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookmarks", "properties"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "card_infos", "users"
  add_foreign_key "dream_addresses", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "professions", "users"
  add_foreign_key "properties", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "schedules", "users"
  add_foreign_key "support_conversations", "supports"
  add_foreign_key "support_messages", "support_conversations"
  add_foreign_key "support_messages", "users"
  add_foreign_key "supports", "users"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "visitors", "users"
end
