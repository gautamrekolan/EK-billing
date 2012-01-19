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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120116220321) do

  create_table "autos", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "horse_id"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "add_day"
    t.integer  "category_id"
    t.string   "description"
    t.integer  "quantity"
    t.decimal  "amount",      :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "category"
    t.string   "name"
    t.decimal  "amount",     :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "delivery_method"
    t.integer  "auto_invoice"
    t.integer  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "description"
    t.string   "notes"
    t.string   "filename"
    t.string   "extension"
    t.integer  "customer_id"
    t.integer  "horse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "horses", :force => true do |t|
    t.string   "reg_name"
    t.string   "barn_name"
    t.string   "notes"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "issued_date"
    t.date     "due_date"
    t.decimal  "amount",      :precision => 8, :scale => 2
    t.string   "notes"
    t.integer  "status_code"
    t.string   "status"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "category_id"
    t.string   "description"
    t.integer  "quantity"
    t.decimal  "amount",      :precision => 8, :scale => 2
    t.integer  "horse_id"
    t.integer  "customer_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "customer_id"
    t.date     "date_received"
    t.string   "payment_method"
    t.string   "payment_notes"
    t.float    "payment_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "status_code"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "name"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
