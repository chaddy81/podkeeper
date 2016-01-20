class CreateRsvpReminders < ActiveRecord::Migration
  def change
    create_table :rsvp_reminders do |t|
      t.integer :event_id
      t.integer :days_before

      t.timestamps
    end

    add_index :rsvp_reminders, :event_id
  end
end
