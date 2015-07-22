class EventNotesController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
    @event_note = EventNote.new(event_id: @event.id)
  end

  def create
    @event_note = EventNote.new(event_note_params)
    @event = Event.includes(:event_reminders, :rsvp_reminders).find(@event_note.event_id)
    if @event_note.valid?

      if @event_note.all_pod_members.to_i > 0
        users = @event.pod.users
      else
        users = []
        rsvps = []
        if @event_note.rsvp_yes.to_i > 0
          rsvps.concat @event.rsvps.where(rsvp_option_id: RsvpOption.yes.id)
        end
        if @event_note.rsvp_no.to_i > 0
          rsvps.concat @event.rsvps.where(rsvp_option_id: RsvpOption.no.id)
        end
        if @event_note.rsvp_maybe.to_i > 0
          rsvps.concat @event.rsvps.where(rsvp_option_id: RsvpOption.maybe.id)
        end
        if @event_note.havent_responded.to_i > 0
          users.concat @event.pod.users.reject { |user| @event.rsvps.pluck(:user_id).include?(user.id) }
        end
        if @event_note.all_except_no_responses.to_i > 0
          users.concat @event.pod.users.reject { |user| @event.rsvps.pluck(:user_id).include?(user.id) }
          rsvps.concat @event.rsvps.where("rsvp_option_id != ?", RsvpOption.no.id)
        end

        rsvps.each { |rsvp| users << rsvp.user }
      end

      users.uniq.each do |user|
        EventMailer.delay.custom_note(@event_note.note, user, @event)
      end

      if @event_note.havent_responded.to_i > 0 || @event_note.all_pod_members.to_i > 0
        @event.pod.invites.unaccepted.each do |invite|
          EventMailer.delay.custom_note(@event_note.note, invite, @event)
        end
      end

      flash[:success] = 'Your event note has been sent out successfully!'
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  private

  def event_note_params
    params.require(:event_note).permit(:note, :havent_responded, :rsvp_yes, :rsvp_no, :rsvp_maybe, :all_pod_members, :all_except_no_responses, :event_id)
  end

end
