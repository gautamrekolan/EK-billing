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

ActiveRecord::Schema.define(:version => 20120124214136) do

  create_table "autos", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "add_day"
    t.string   "description"
    t.integer  "quantity"
    t.decimal  "amount",      :precision => 8, :scale => 2
    t.integer  "customer_id"
    t.integer  "horse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "category"
    t.string   "name"
    t.decimal  "amount",          :precision => 8, :scale => 2
    t.integer  "organization_id"
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
    t.string   "home"
    t.string   "cell"
    t.string   "work"
    t.string   "email"
    t.integer  "active"
    t.string   "delivery_method"
    t.integer  "auto_invoice"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customs", :force => true do |t|
    t.integer  "organization_id"
    t.string   "checks_payable_to"
    t.string   "signoff_line"
    t.integer  "customer_info_check"
    t.string   "logo_extension"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_filename"
  end

  create_table "documents", :force => true do |t|
    t.string   "description"
    t.string   "notes"
    t.string   "filename"
    t.string   "extension"
    t.integer  "organization_id"
    t.integer  "customer_id"
    t.integer  "horse_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "horses", :force => true do |t|
    t.string   "reg_name"
    t.string   "barn_name"
    t.string   "breed"
    t.integer  "age"
    t.string   "notes"
    t.integer  "organization_id"
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
    t.decimal  "amount",          :precision => 8, :scale => 2
    t.integer  "status_code"
    t.string   "status"
    t.string   "notes"
    t.integer  "organization_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "category_id"
    t.string   "description"
    t.integer  "quantity"
    t.decimal  "amount",          :precision => 8, :scale => 2
    t.integer  "organization_id"
    t.integer  "customer_id"
    t.integer  "horse_id"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.string   "contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :id => false, :force => true do |t|
    t.integer  "id"
    t.datetime "date"
    t.string   "payment_type"
    t.string   "notes"
    t.decimal  "amount",       :precision => 8, :scale => 2
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "status_code"
    t.string   "status"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "access"
    t.integer  "organization_id"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
