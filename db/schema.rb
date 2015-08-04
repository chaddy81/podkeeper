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

ActiveRecord::Schema.define(version: 20150723144101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_levels", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "note_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "invite_id"
  end

  add_index "comments", ["invite_id"], name: "index_comments_on_invite_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0
    t.integer  "attempts",               default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "deleted_pod_attributes", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "creator_first_name",        limit: 255
    t.string   "creator_last_name",         limit: 255
    t.integer  "number_of_pod_admins"
    t.integer  "number_of_members"
    t.integer  "number_of_open_invites"
    t.integer  "number_of_discussions"
    t.integer  "number_of_comments"
    t.integer  "number_of_upcoming_events"
    t.integer  "number_of_past_events"
    t.integer  "number_of_task_lists"
    t.integer  "number_of_tasks"
    t.integer  "number_of_documents"
    t.string   "pod_name",                  limit: 255
    t.integer  "deleter_id"
    t.string   "deleter_first_name",        limit: 255
    t.string   "deleter_last_name",         limit: 255
    t.datetime "pod_deleted_at"
    t.datetime "pod_created_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "pod_id"
  end

  create_table "duplicate_events", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "organizer_id"
    t.time     "start_time"
    t.date     "start_date"
    t.time     "end_time"
    t.date     "end_date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "time_zone",    limit: 255
  end

  create_table "email_notifications", force: :cascade do |t|
    t.string   "email"
    t.string   "sg_event_id"
    t.string   "sg_message_id"
    t.datetime "timestamp"
    t.string   "smtp_id"
    t.string   "event"
    t.string   "email_id"
    t.string   "uid"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "ip"
    t.string   "useragent"
    t.string   "url"
    t.string   "type"
    t.string   "status"
    t.string   "response"
    t.string   "reason"
    t.string   "category"
    t.string   "unique_arg_key"
    t.string   "attempt"
  end

  create_table "email_types", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "email",         limit: 255
    t.boolean  "default",                   default: true
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "email_type_id"
    t.integer  "user_id"
  end

  create_table "event_reminders", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "days_before"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "event_reminders", ["event_id"], name: "index_event_reminders_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "description"
    t.string   "location",     limit: 255
    t.string   "phone",        limit: 255
    t.string   "street",       limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "zipcode",      limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "require_rsvp",             default: true
    t.integer  "pod_id"
    t.integer  "organizer_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "completed",                default: false
    t.string   "time_zone",    limit: 255
    t.boolean  "confirmed",                default: false
    t.datetime "confirmed_at"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "notes"
    t.boolean  "single_event",             default: true
    t.integer  "weeks"
  end

  create_table "invalid_emails", force: :cascade do |t|
    t.integer  "pod_id"
    t.integer  "user_id"
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "invalid_emails", ["pod_id"], name: "index_invalid_emails_on_pod_id", using: :btree
  add_index "invalid_emails", ["user_id"], name: "index_invalid_emails_on_user_id", using: :btree

  create_table "invite_requests", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "invite_sets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "pod_id"
    t.string   "email",      limit: 255
    t.string   "first_name", limit: 255
    t.string   "last_name",  limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "accepted",               default: false
    t.integer  "invitee_id"
    t.integer  "inviter_id"
    t.string   "auth_token", limit: 255
    t.string   "pod_name",   limit: 255
    t.boolean  "declined",               default: false
  end

  create_table "kids", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id"
    t.integer  "pod_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "list_items", force: :cascade do |t|
    t.integer  "list_id"
    t.text     "notes"
    t.text     "item"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "list_types", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "lists", force: :cascade do |t|
    t.integer  "list_type_id"
    t.string   "name",                       limit: 255
    t.text     "details"
    t.integer  "creator_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "pod_id"
    t.boolean  "notification_has_been_sent",             default: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "topic",        limit: 255
    t.text     "body"
    t.integer  "event_id"
    t.integer  "user_id"
    t.boolean  "is_urgent",                default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "pod_id"
    t.datetime "sort_by_date"
    t.string   "token",        limit: 255
    t.integer  "comment_id"
  end

  add_index "notes", ["comment_id"], name: "index_notes_on_comment_id", using: :btree

  create_table "pod_categories", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "pod_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "pod_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "get_ready_bar_expanded", default: true
    t.integer  "access_level_id"
    t.datetime "deleted_at"
    t.datetime "last_visit_notes"
    t.datetime "last_visit_events"
    t.datetime "last_visit_lists"
    t.datetime "last_visit_files"
  end

  create_table "pod_sub_categories", force: :cascade do |t|
    t.integer  "pod_category_id"
    t.string   "name",            limit: 255
    t.string   "display_name",    limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "pods", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "pod_category_id"
    t.integer  "organizer_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.boolean  "active",                          default: true
    t.text     "description"
    t.string   "slug",                limit: 255
    t.integer  "pod_sub_category_id"
    t.datetime "deleted_at"
  end

  create_table "reminders", force: :cascade do |t|
    t.integer  "invite_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rsvp_options", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "display_name", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "color",        limit: 255
  end

  create_table "rsvp_reminders", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "days_before"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "rsvp_reminders", ["event_id"], name: "index_rsvp_reminders_on_event_id", using: :btree

  create_table "rsvps", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "rsvp_option_id"
    t.text     "comments"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "number_of_kids",   default: 0
    t.integer  "number_of_adults", default: 0
  end

  create_table "settings", force: :cascade do |t|
    t.boolean  "note_new_notice",          default: true
    t.boolean  "note_urgent_notice",       default: true
    t.boolean  "note_reply_to_you_notice", default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "user_id"
    t.boolean  "note_reply_to_any_notice", default: true
    t.boolean  "event_new_notice",         default: true
    t.boolean  "event_update_notice",      default: true
    t.boolean  "event_reminder_notice",    default: true
    t.integer  "pod_id"
  end

  create_table "site_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "site_comments", ["user_id"], name: "index_site_comments_on_user_id", using: :btree

  create_table "unbounces", force: :cascade do |t|
    t.string   "first_name",   limit: 255
    t.string   "string",       limit: 255
    t.string   "last_name",    limit: 255
    t.string   "email",        limit: 255
    t.string   "ip_address",   limit: 255
    t.string   "page_id",      limit: 255
    t.string   "page_name",    limit: 255
    t.string   "page_url",     limit: 255
    t.string   "page_variant", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "token",        limit: 255
    t.string   "utm_source",   limit: 255
    t.string   "utm_medium",   limit: 255
    t.string   "utm_content",  limit: 255
    t.string   "utm_campaign", limit: 255
  end

  create_table "uploaded_files", force: :cascade do |t|
    t.string   "file",              limit: 255
    t.string   "description",       limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "pod_membership_id"
    t.text     "url"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "password_digest",         limit: 255
    t.datetime "last_login"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "auth_token",              limit: 255
    t.string   "password_reset_token",    limit: 255
    t.datetime "password_reset_sent_at"
    t.boolean  "active",                              default: true
    t.boolean  "is_admin",                            default: false
    t.string   "phone",                   limit: 255
    t.string   "time_zone",               limit: 255
    t.string   "email",                   limit: 255
    t.integer  "last_pod_visited_id"
    t.boolean  "daily_digest",                        default: true
    t.boolean  "has_seen_splash_message",             default: false
    t.boolean  "has_seen_get_pod_going",              default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
  end

end
