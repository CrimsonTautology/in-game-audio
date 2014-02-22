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

ActiveRecord::Schema.define(version: 20140222182350) do

  create_table "directories", force: true do |t|
    t.boolean  "root",       default: false
    t.string   "name",                       null: false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_path"
  end

  add_index "directories", ["full_path"], name: "index_directories_on_full_path", using: :btree
  add_index "directories", ["parent_id", "name"], name: "index_directories_on_parent_id_and_name", using: :btree
  add_index "directories", ["root"], name: "index_directories_on_root", using: :btree

  create_table "songs", force: true do |t|
    t.string   "name",                             null: false
    t.integer  "directory_id",                     null: false
    t.string   "title"
    t.string   "album"
    t.string   "artist"
    t.float    "duration",           default: 0.0
    t.integer  "uploader_id"
    t.integer  "play_count"
    t.string   "file_hash"
    t.boolean  "map_themeable"
    t.boolean  "user_themeable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sound_fingerprint"
    t.string   "full_path"
    t.string   "sound"
    t.string   "sound_file_name"
    t.integer  "sound_file_size"
    t.string   "sound_content_type"
  end

  add_index "songs", ["directory_id", "name"], name: "index_songs_on_directory_id_and_name", using: :btree
  add_index "songs", ["full_path"], name: "index_songs_on_full_path", using: :btree
  add_index "songs", ["title", "album", "artist"], name: "index_songs_on_title_and_album_and_artist", using: :btree

end
