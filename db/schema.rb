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

ActiveRecord::Schema.define(version: 20150521200916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "company_url"
    t.string   "angellist_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "angellist_id"
  end

  create_table "compensations", force: true do |t|
    t.integer  "job_id"
    t.integer  "salary_min"
    t.integer  "salary_max"
    t.float    "equity_min"
    t.float    "equity_max"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "compensations", ["job_id"], name: "index_compensations_on_job_id", using: :btree

  create_table "job_jobroles", force: true do |t|
    t.integer  "job_id"
    t.integer  "jobrole_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_jobroles", ["job_id"], name: "index_job_jobroles_on_job_id", using: :btree
  add_index "job_jobroles", ["jobrole_id"], name: "index_job_jobroles_on_jobrole_id", using: :btree

  create_table "job_skills", force: true do |t|
    t.integer  "job_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_skills", ["job_id"], name: "index_job_skills_on_job_id", using: :btree
  add_index "job_skills", ["skill_id"], name: "index_job_skills_on_skill_id", using: :btree

  create_table "jobroles", force: true do |t|
    t.integer  "angellist_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", force: true do |t|
    t.string   "title"
    t.integer  "company_id"
    t.datetime "created"
    t.datetime "last_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "angellist_id"
    t.integer  "jobtype_id"
  end

  add_index "jobs", ["company_id"], name: "index_jobs_on_company_id", using: :btree
  add_index "jobs", ["jobtype_id"], name: "index_jobs_on_jobtype_id", using: :btree

  create_table "jobtypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logos", force: true do |t|
    t.integer  "company_id"
    t.string   "thumb_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logos", ["company_id"], name: "index_logos_on_company_id", using: :btree

  create_table "skills", force: true do |t|
    t.integer  "angellist_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
