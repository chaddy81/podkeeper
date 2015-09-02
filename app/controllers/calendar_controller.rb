class CalendarController < ApplicationController
  def index
    @events = current_user_events
  end

  def show
    @events = current_user_events
    @event = Event.includes(:organizer).find(params[:id])
  end

  def calendar_events
    @events = Event.confirmed.where(start_date: params[:start_date]).includes(:organizer, :pod, :rsvps, pod: :organizer).order('start_date ASC').order('start_time ASC')
  end

  private

  def current_user_events
    events = []
    # Event.includes(pod: { :pod_memberships => :user}).where(pod_memberships: { user_id: current_user.id })
    current_user.pod_memberships.each do |pm|
      pm.pod.events.confirmed.order('start_date ASC').order('start_time ASC').each do |ev|
        events << ev
      end
    end

    return events
  end
end
