class AddRemindersToAllExistingEvents < ActiveRecord::Migration
  def change
    Event.where(completed: false).each do |event|
      event.rsvp_reminders.create(days_before: 14)
      event.rsvp_reminders.create(days_before: 4)
      event.event_reminders.create(days_before: 7)
      event.event_reminders.create(days_before: 1)
    end
  end
end
