# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121211183953) do

  create_table "contouring_sessions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "template_study_id"
    t.string   "rtstruct_file_name"
    t.string   "rtstruct_content_type"
    t.integer  "rtstruct_file_size"
    t.datetime "rtstruct_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "ready"
    t.boolean  "expert"
    t.string   "expert_note"
    t.string   "name"
  end

  create_table "contours", :force => true do |t|
    t.integer  "structure_id"
    t.string   "ref_roi_num"
    t.string   "ref_sop_instance_uid"
    t.text     "cont_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "metric_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "method_name"
  end

  create_table "metrics", :force => true do |t|
    t.integer  "metric_type_id"
    t.integer  "structure_1_id"
    t.integer  "structure_2_id"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "structure_sets", :force => true do |t|
    t.integer  "template_study_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "structures", :force => true do |t|
    t.integer  "contouring_session_id"
    t.string   "structure_name"
    t.string   "mask_file_name"
    t.string   "mask_content_type"
    t.integer  "mask_file_size"
    t.datetime "mask_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rt_modality"
    t.string   "rt_roi_num"
    t.string   "rt_description"
    t.integer  "structure_sets_id"
    t.integer  "structure_set_id"
  end

  create_table "template_studies", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.text     "metadata"
    t.string   "nii_file_name"
    t.string   "nii_content_type"
    t.integer  "nii_file_size"
    t.datetime "nii_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "x_scale"
    t.decimal  "y_scale"
    t.decimal  "x_orig"
    t.decimal  "y_orig"
    t.decimal  "z_orig"
    t.string   "ts_dicom"
    t.string   "ts_json"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "organization"
    t.string   "research_area"
    t.string   "how_learned"
    t.string   "website"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "login"
  end

end
