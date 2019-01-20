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

ActiveRecord::Schema.define(version: 2019_01_20_043951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "laboratories", force: :cascade do |t|
    t.string "nombre"
    t.string "facultad"
    t.string "campus"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "laboratories_students", id: false, force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "laboratory_id", null: false
    t.index ["laboratory_id", "student_id"], name: "index_laboratories_students_on_laboratory_id_and_student_id"
    t.index ["student_id", "laboratory_id"], name: "index_laboratories_students_on_student_id_and_laboratory_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "rfid"
    t.string "nombre"
    t.string "nalumno"
    t.string "sit_academica"
    t.string "correo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
