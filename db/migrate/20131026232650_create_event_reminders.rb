class CreateEventReminders < ActiveRecord::Migration
  def change
    create_table :event_reminders do |t|
      t.integer :event_id
      t.integer :days_before

      t.timestamps
    end

    add_index :event_reminders, :event_id
  end
end
