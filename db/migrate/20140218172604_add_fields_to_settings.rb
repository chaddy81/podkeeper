class AddFieldsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :note_reply_to_any_notice, :boolean, default: true
    add_column :settings, :event_new_notice, :boolean, default: true
    add_column :settings, :event_update_notice, :boolean, default: true
    add_column :settings, :event_reminder_notice, :boolean, default: true
    add_column :settings, :daily_digest, :boolean, default: true
  end
end
