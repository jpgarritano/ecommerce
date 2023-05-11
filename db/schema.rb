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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20230509201614) do

  create_table "categories", :force => true do |t|
    t.string   "name",       :limit => 60
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "categories", ["user_id"], :name => "index_categories_on_user_id"

  create_table "category_products", :force => true do |t|
    t.integer "product_id"
    t.integer "category_id"
  end

  add_index "category_products", ["category_id"], :name => "index_category_products_on_category_id"
  add_index "category_products", ["product_id"], :name => "index_category_products_on_product_id"

  create_table "customers", :force => true do |t|
    t.string   "email",      :limit => 100
    t.string   "first_name", :limit => 50
    t.string   "last_name",  :limit => 50
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "dimentions", :force => true do |t|
    t.float    "height"
    t.float    "weight"
    t.float    "width"
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "dimentions", ["product_id"], :name => "index_dimentions_on_product_id"

  create_table "images", :force => true do |t|
    t.integer  "product_id"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "images", ["product_id"], :name => "index_images_on_product_id"

  create_table "orders", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.float    "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "orders", ["customer_id"], :name => "index_orders_on_customer_id"
  add_index "orders", ["product_id"], :name => "index_orders_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.integer  "stock"
    t.float    "price"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "products", ["user_id"], :name => "index_products_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
