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

ActiveRecord::Schema[8.1].define(version: 2026_04_20_000003) do
  create_table "service_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "requester_id", null: false
    t.integer "service_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["requester_id"], name: "index_service_requests_on_requester_id"
    t.index ["service_id"], name: "index_service_requests_on_service_id"
    t.index ["status"], name: "index_service_requests_on_status"
  end

  create_table "services", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration", default: 1, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.integer "service_request_id", null: false
    t.string "transaction_type", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["service_request_id"], name: "index_transactions_on_service_request_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "balance"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "service_requests", "services"
  add_foreign_key "service_requests", "users", column: "requester_id"
  add_foreign_key "services", "users"
  add_foreign_key "transactions", "service_requests"
  add_foreign_key "transactions", "users"
end
