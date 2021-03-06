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

ActiveRecord::Schema.define(:version => 20130105181307) do

  create_table "posts", :force => true do |t|
    t.text     "text"
    t.string   "password_hash"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "parent_id"
    t.integer  "topic_id"
    t.integer  "poster_id"
    t.integer  "sub_id"
    t.string   "password_id"
  end

  add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"

  create_table "posts_users", :id => false, :force => true do |t|
    t.integer "flagged_post_id"
    t.integer "flagger_id"
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "section"
    t.integer  "sub_id"
  end

  add_index "topics", ["section"], :name => "index_topics_on_section"

  create_table "users", :force => true do |t|
    t.string   "ip"
    t.boolean  "blocked",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "users", ["ip"], :name => "index_users_on_ip"

end
