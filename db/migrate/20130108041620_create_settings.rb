class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :note_new_notice, default: true
      t.boolean :note_urgent_notice, default: true
      t.boolean :event_two_week_notice, default: true
      t.boolean :event_one_week_notice, default: true
      t.boolean :event_three_day_notice, default: true
      t.boolean :task_list_create_notice, default: true
      t.boolean :note_reply_to_you_notice, default: true

      t.timestamps
    end
  end
end
