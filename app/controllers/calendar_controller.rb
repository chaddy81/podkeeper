class CalendarController < ApplicationController
  def index
    if params[:start_date]
      @events = current_user_events.select { |ev| ev.start_date.month == params[:start_date].to_date.month && ev.start_date.year == params[:start_date].to_date.year }
    else
      @events = current_user_events_upcoming.select { |ev| ev.start_date.month == Date.today.month && ev.start_date.year == Date.today.year }
    end
  end

  def show
    @events = current_user_events.select { |ev| ev.start_date.month == params[:start_date].to_date.month && ev.start_date.year == params[:start_date].to_date.year }
    @event = Event.includes(:organizer).find(params[:id])
  end

  def calendar_events
    @events = current_user_events.select { |ev| ev.start_date == params[:start_date].to_date }
  end

  private

  def current_user_events
    events = []

    current_user.pod_memberships.includes(:pod).each do |pm|
      pm.pod.events.confirmed.order(:start_date, :start_time).each do |ev|
        events << ev
      end
    end

    return events
  end

  def current_user_events_upcoming
    events = []

    current_user.pod_memberships.includes(:pod).each do |pm|
      pm.pod.events.confirmed.upcoming.order(:start_date, :start_time).each do |ev|
        events << ev
      end
    end

    return events
  end
end
