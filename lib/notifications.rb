class Notifications
  include MailHelper

  def invite_to_create_a_pod_four_day_reminders
    date = 4.days.ago
    invites = Invite.where('pod_id IS NULL AND accepted = false AND created_at >= ? AND created_at <= ?', date - 2.days, date + 2.days)
    invites.each do |invite|
      time_zone = get_invite_time_zone(invite)
      current_time = DateTime.now.in_time_zone(time_zone)
      midnight = current_time.midnight
      if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && invite.created_at.in_time_zone(time_zone).to_date == date.in_time_zone(time_zone).to_date
        InviteMailer.send_invite_to_create_a_pod_four_day_reminder(invite).deliver_now
      end
    end
  end

  def invite_to_create_a_pod_eleven_day_reminders
    date = 11.days.ago
    invites = Invite.where('pod_id IS NULL AND accepted = false AND created_at >= ? AND created_at <= ?', date - 2.days, date + 2.days)
    invites.each do |invite|
      time_zone = get_invite_time_zone(invite)
      current_time = DateTime.now.in_time_zone(time_zone)
      midnight = current_time.midnight
      if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && invite.created_at.in_time_zone(time_zone).to_date == date.in_time_zone(time_zone).to_date
        InviteMailer.send_invite_to_create_a_pod_eleven_day_reminder(invite).deliver_now
      end
    end
  end

  def invite_to_join_a_pod_two_day_reminders
    date = 2.days.ago
    invites = Invite.where('pod_id IS NOT NULL AND accepted = false AND created_at >= ? AND created_at <= ?', date - 2.days, date + 2.days)
    invites.each do |invite|
      time_zone = get_invite_time_zone(invite)
      current_time = DateTime.now.in_time_zone(time_zone)
      midnight = current_time.midnight
      if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && invite.created_at.in_time_zone(time_zone).to_date == date.in_time_zone(time_zone).to_date
        InviteMailer.send_invite_to_join_a_pod_two_day_reminder(invite).deliver_now
      end
    end
  end

  def invite_to_join_a_pod_four_day_reminders
    date = 4.days.ago
    invites = Invite.where('pod_id IS NOT NULL AND accepted = false AND created_at >= ? AND created_at <= ?', date - 2.days, date + 2.days)
    invites.each do |invite|
      time_zone = get_invite_time_zone(invite)
      current_time = DateTime.now.in_time_zone(time_zone)
      midnight = current_time.midnight
      if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && invite.created_at.in_time_zone(time_zone).to_date == date.in_time_zone(time_zone).to_date
        InviteMailer.send_invite_to_join_a_pod_four_day_reminder(invite).deliver_now
      end
    end
  end

  def invite_to_join_a_pod_nine_day_reminders
    date = 9.days.ago
    invites = Invite.where('pod_id IS NOT NULL AND accepted = false AND created_at >= ? AND created_at <= ?', date - 2.days, date + 2.days)
    invites.each do |invite|
      time_zone = get_invite_time_zone(invite)
      current_time = DateTime.now.in_time_zone(time_zone)
      midnight = current_time.midnight
      if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && invite.created_at.in_time_zone(time_zone).to_date == date.in_time_zone(time_zone).to_date
        InviteMailer.send_invite_to_join_a_pod_nine_day_reminder(invite).deliver_now
      end
    end
  end

  def rsvp_reminders
    events = Event.confirmed.upcoming.requires_rsvp
    events.each do |event|
      event.rsvp_reminders.each do |rsvp_reminder|
        event.pod.users.each do |user|
          current_time = DateTime.now.in_time_zone(user.time_zone)
          midnight = current_time.midnight
          if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && event.start_date == rsvp_reminder.days_before.days.from_now.in_time_zone(user.time_zone).to_date
            unless user.settings.where(pod_id: event.pod.id).last.event_reminder_notice == false
              EventMailer.reminder_to_rsvp(event, user).deliver_now unless Rsvp.where(user_id: user.id, event_id: event.id).any?
            end
          end
        end

        event.pod.invites.unaccepted.each do |invite|
          current_time = DateTime.now.in_time_zone(event.time_zone)
          midnight = current_time.midnight
          if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && event.start_date == rsvp_reminder.days_before.days.from_now.in_time_zone(event.time_zone).to_date
            EventMailer.reminder_to_rsvp(event, invite).deliver_now
          end
        end
      end
    end
  end

  def upcoming_event_reminders
    events = Event.confirmed.upcoming.requires_rsvp
    events.each do |event|
      event.event_reminders.each do |event_reminder|
        event.pod.users.each do |user|
          current_time = DateTime.now.in_time_zone(user.time_zone)
          midnight = current_time.midnight
          if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && event.start_date == event_reminder.days_before.days.from_now.in_time_zone(user.time_zone).to_date
            rsvp = user.rsvps.where(event_id: event.id).last
            unless user.settings.where(pod_id: event.pod.id).last.event_reminder_notice == false
              EventMailer.reminder(event, user).deliver_now unless rsvp && rsvp.rsvp_option_is_no?
            end
          end
        end

        event.pod.invites.unaccepted.each do |invite|
          current_time = DateTime.now.in_time_zone(event.time_zone)
          midnight = current_time.midnight
          if current_time >= midnight + 11.hours && current_time < midnight + 12.hours && event.start_date == event_reminder.days_before.days.from_now.in_time_zone(event.time_zone).to_date
            EventMailer.reminder(event, invite).deliver_now
          end
        end
      end
    end
  end

  def urgent_note_posted(note)
    note.pod.users.each do |user|
      if user.settings.where(pod_id: note.pod.id).last.note_urgent_notice == true
        NoteMailer.urgent_note_posted(user, note).deliver_now unless user == note.user
      end
    end

    invites = note.pod.invites.unaccepted
    invites.each do |invite|
      NoteMailer.urgent_note_posted_to_non_member(invite, note).deliver_now
    end
  end

  def note_posted(note)
    note.pod.users.each do |user|
      if user.settings.where(pod_id: note.pod.id).last.note_new_notice == true
        NoteMailer.note_posted(user, note).deliver_now unless user == note.user
      end
    end

    invites = note.pod.invites.unaccepted
    invites.each do |invite|
      NoteMailer.note_posted(invite, note).deliver_now
    end
  end

  def reply_to_my_note(comment)
    comment.note.pod.users.each do |user|
      if user.settings.where(pod_id: comment.note.pod.id).last.note_reply_to_you_notice == true && user.settings.where(pod_id: comment.note.pod.id).last.note_reply_to_any_notice == false
        if user == comment.note.user
          NoteMailer.reply_to_my_note(user, comment).deliver_now unless user == comment.user
        end
      end

      if user.settings.where(pod_id: comment.note.pod.id).last.note_reply_to_you_notice == false && user.settings.where(pod_id: comment.note.pod.id).last.note_reply_to_any_notice == true
        NoteMailer.reply_to_my_note(user, comment).deliver_now unless user == comment.user
      end

      if user.settings.where(pod_id: comment.note.pod.id).last.note_reply_to_you_notice == true && user.settings.where(pod_id: comment.note.pod.id).last.note_reply_to_any_notice == true
        NoteMailer.reply_to_my_note(user, comment).deliver_now unless user == comment.user
      end
    end

    invites = comment.note.pod.invites.unaccepted
    invites.each do |invite|
      NoteMailer.reply_to_my_note(invite, comment).deliver_now
    end
  end

  def get_invite_time_zone(invite)
    if invite.invitee.nil? || invite.invitee.time_zone.nil?
      time_zone = 'Eastern Time (US & Canada)'
    else
      time_zone = invite.invitee.time_zone
    end
  end

  def daily_digest
    users = User.where(daily_digest: true)
    count = 0
    users.each do |user|
      unless user.pod_memberships.empty?
        user.pod_memberships.each do |pm|
          if pm.access_level && pm.pod_admin?
            if PodMembership.joined_yesterday(pm.pod, user).any? || Invite.declined_yesterday(pm.pod).any? ||
              PodMembership.left_yesterday(pm.pod).any?
              count +=1
            end
          end

          if pm.pod.events.confirmed.updated_yesterday.any? ||
            pm.pod.events.confirmed.where(start_date: Date.today).any? ||
            pm.pod.notes.updated_yesterday.any? ||
            pm.pod.uploaded_files.updated_yesterday.any?

            count += 1
          end
        end
        if count > 0
          DailyDigestMailer.daily_digest(user).deliver_now
          count = 0
        end
      end
    end
  end

  def new_list_notification(list)
    list.pod.users.each do |user|
      ListMailer.notification(list, user).deliver_now
    end

    list.pod.invites.unaccepted.each do |invite|
      ListMailer.notification(list, invite).deliver_now
    end
  end

  # handle_asynchronously :urgent_note_posted
  # handle_asynchronously :note_posted
  # handle_asynchronously :reply_to_my_note
  handle_asynchronously :new_list_notification

end
