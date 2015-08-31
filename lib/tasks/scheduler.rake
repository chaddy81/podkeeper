desc "This task is called by the Heroku scheduler add-on"

task mark_events_as_complete: :environment do
  Event.mark_events_as_complete
end

task invite_to_create_a_pod_four_day_reminders: :environment do
  Notifications.new.invite_to_create_a_pod_four_day_reminders
end

task invite_to_create_a_pod_eleven_day_reminders: :environment do
  Notifications.new.invite_to_create_a_pod_eleven_day_reminders
end

task invite_to_join_a_pod_two_day_reminders: :environment do
  Notifications.new.invite_to_join_a_pod_two_day_reminders
end

task invite_to_join_a_pod_nine_day_reminders: :environment do
  Notifications.new.invite_to_join_a_pod_nine_day_reminders
end

task rsvp_reminders: :environment do
  Notifications.new.rsvp_reminders
end

task upcoming_event_reminders: :environment do
  Notifications.new.upcoming_event_reminders
end

task update_get_ready_bar_status: :environment do
  PodMembership.reset_get_ready_bar_visibility
end

task toggle_expired_urgent_notes: :environment do
  Note.expire_urgent_notes
end

task send_daily_digest: :environment do
  Notifications.new.daily_digest
end