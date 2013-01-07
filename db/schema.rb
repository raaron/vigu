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

ActiveRecord::Schema.define(:version => 20130103192324) do

  create_table "images", :force => true do |t|
    t.integer  "paragraph_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "position",           :default => 0
    t.integer  "width"
    t.integer  "height"
  end

  add_index "images", ["paragraph_id"], :name => "index_images_on_paragraph_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "paragraphs", :force => true do |t|
    t.string   "section"
    t.integer  "page_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "position",   :default => 0
    t.date     "date"
  end

  add_index "paragraphs", ["page_id"], :name => "index_paragraphs_on_page_id"

  create_table "translations", :force => true do |t|
    t.string  "locale"
    t.string  "key"
    t.text    "value"
    t.text    "interpolations"
    t.boolean "is_proc",        :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "street"
    t.string   "plz"
    t.string   "place"
    t.string   "country"
    t.boolean  "bought_book",     :default => false
    t.boolean  "newsletter",      :default => true
    t.string   "password_digest"
    t.boolean  "admin",           :default => false
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
