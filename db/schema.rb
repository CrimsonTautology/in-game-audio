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

ActiveRecord::Schema.define(version: 20140117182804) do

  create_table "directories", force: true do |t|
    t.boolean  "root",       default: false
    t.string   "name",                       null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "songs", force: true do |t|
    t.string   "name",           null: false
    t.integer  "directory_id",   null: false
    t.string   "title"
    t.string   "album"
    t.string   "artist"
    t.integer  "duration"
    t.integer  "uploader_id"
    t.integer  "play_count"
    t.string   "file_hash"
    t.boolean  "map_themeable"
    t.boolean  "user_themeable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
