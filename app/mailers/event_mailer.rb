class EventMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'PodKeeper <podmember@email.podkeeper.com>'

  helper :application # for use in mailer views
  include ApplicationHelper # for use in mailer
  helper :events

  def cancelled(event, user)
    @event = event
    @user = user
    @email = user.email
    mail to: user.email,
         subject: "Event Cancelled - #{event.name} with #{event.pod.name}",
         reply_to: event.organizer.email,
         from: "#{event.organizer.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def custom_note(note, user, event)
    @user = user
    @note = note
    @email = user.email
    @event = event
    @twolines = true
    mail to: user.email,
         subject: "Note regarding #{event.name} with the #{event.pod.name}",
         reply_to: event.organizer.email,
         from: "#{event.organizer.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def new_event(event, user)
    Time.zone = user.time_zone
    @user = user
    @email = user.email
    @event = event
    @twolines = true
    mail to: user.email,
         subject: "Invitation to #{event.name} with #{event.pod.name}",
         reply_to: event.organizer.email,
         from: "#{event.organizer.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def new_event_non_member(invite, event)
    @invite = invite
    @email = invite.email
    @event = event
    @podanize_member = User.where(email: invite.email).any?
    @twolines = true
    mail to: invite.email,
         subject: "Invitation to #{event.name} with #{event.pod.name}",
         reply_to: event.organizer.email,
         from: "#{event.organizer.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def event_updated(user, event)
    @rsvp = user.rsvps.where(event_id: event.id).last || Rsvp.new
    @user = user
    @event = event
    @email = @user.email
    @twolines = true
    mail to: user.email,
         subject: "Event Update - #{event.name} with the #{event.pod.name}",
         reply_to: event.organizer.email,
         from: "#{event.organizer.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def event_updated_to_non_member(invite, event)
    @rsvp = Rsvp.new
    @user = invite
    @event = event
    @email = invite.email
    @twolines = true
    mail to: invite.email,
         subject: "Event Update - #{event.name} with the #{event.pod.name}",
         reply_to: event.organizer.email,
         template_name: 'event_updated',
         from: "#{event.organizer.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def reminder_to_rsvp(event, user)
    @user = user
    Time.zone = @user.time_zone unless @user.class.to_s == 'Invite'
    @event = event
    @email = user.email
    @twolines = true
    mail to: "#{user.full_name} <#{user.email}>",
         subject: "Reminder to RSVP - #{event.name} with #{event.pod.name}",
         reply_to: event.organizer.email,
         from: "#{event.organizer.full_name} <podmember@email.podkeeper.com>"
  end

  def reminder(event, user)
    @user = user
    @event = event
    @email = @user.email
    Time.zone = @user.time_zone unless @user.class.to_s == 'Invite'
    @rsvp = user.rsvps.where(event_id: event.id).last || 'Not Responded' unless @user.class.to_s == 'Invite'
    @twolines = true
    mail to: user.email,
         subject: "Event Reminder - #{event.name} on #{l event.start_date, format: '%m/%d'}",
         reply_to: event.organizer.email,
         from: "#{event.organizer.full_name} <podmember@email.podkeeper.com>"
  end

  def new_event_contact(events, pod, previous_organizer)
    @events = events
    @previous_organizer = previous_organizer
    @email = pod.organizer.email
    @user = pod.organizer
    @pod = pod
    mail to: "#{pod.organizer.full_name} <#{pod.organizer.email}>",
         subject: "You are the new Event Contact - #{pod.name}"
  end

end