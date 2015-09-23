class CalendarController < ApplicationController
  def index
    if params[:start_date]
      @events = current_user_events.select { |ev| ev.start_date.month == params[:start_date].to_date.month }
    else
      @events = current_user_events.select { |ev| ev.start_date.month == Date.today.month }
    end
  end

  def show
    @events = current_user_events
    @event = Event.includes(:organizer).find(params[:id])
  end

  def calendar_events
    @events = current_user_events.select { |ev| ev.start_date == params[:start_date].to_date }
    puts @events.count
  end

  private

  def current_user_events
    events = []

    current_user.pod_memberships.includes(:pod).each do |pm|
      pm.pod.events.confirmed.order('start_date ASC').order('start_time ASC').each do |ev|
        events << ev
      end
    end

    return events
  end
end
