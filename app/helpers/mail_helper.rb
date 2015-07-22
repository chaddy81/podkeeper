module MailHelper
  def event_location event
    event_details = [event.location, event.street, event.city, event.state].reject(&:blank?)
    event_details.join(', ') if event_details.count > 1
  end

  def rsvp_count pm, user
    rsvp_count = 0

    unless pm.pod.events.upcoming.confirmed.where(require_rsvp: true).empty?
      pm.pod.events.upcoming.confirmed.where(require_rsvp: true).where('start_date > ?', Date.yesterday).each do |event|
        rsvp_count += event.rsvps.where(user_id: user.id).count
      end
    end
    rsvp_count
  end

  def new_items pm
    @new_items = pm.pod.events.confirmed.updated_yesterday.any? || pm.pod.events.confirmed.where(start_date: Date.today).any? || pm.pod.notes.updated_yesterday.any? || pm.pod.uploaded_files.updated_yesterday.any?
  end

end
