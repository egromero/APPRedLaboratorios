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

ActiveRecord::Schema.define(version: 2020_03_30_010056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "flayers", force: :cascade do |t|
    t.string "tittle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "laboratories", force: :cascade do |t|
    t.string "nombre"
    t.string "facultad"
    t.string "campus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_laboratories_on_user_id"
  end

  create_table "laboratories_students", id: false, force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "laboratory_id", null: false
    t.index ["laboratory_id", "student_id"], name: "index_laboratories_students_on_laboratory_id_and_student_id"
    t.index ["student_id", "laboratory_id"], name: "index_laboratories_students_on_student_id_and_laboratory_id"
  end

  create_table "records", force: :cascade do |t|
    t.string "tipo"
    t.bigint "student_id"
    t.datetime "created_at"
    t.integer "lab_id"
    t.boolean "foul", default: false
    t.string "description"
    t.index ["student_id"], name: "index_records_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "rfid"
    t.string "nombre"
    t.string "nalumno"
    t.string "sit_academica"
    t.string "correo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rut"
    t.boolean "status"
  end

  create_table "totems", force: :cascade do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rol"
    t.integer "lab_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.string "rut"
    t.string "motivo"
    t.string "institucion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lab_id"
    t.string "other"
    t.integer "quantity"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "laboratories", "users"
  add_foreign_key "records", "students"
end
