class CalendarController < ApplicationController
  def index
    session[:calendar_date] = ''
    if params[:start_date]
      @events = current_user_events.select { |ev| ev.start_date.month == params[:start_date].to_date.month && ev.start_date.year == params[:start_date].to_date.year }
    else
      @events = current_user_events.select { |ev| ev.start_date.month == Date.today.month && ev.start_date.year == Date.today.year }
    end
  end

  def show
    unless session[:calendar_date].blank?
      @events = current_user_events.select { |ev| ev.start_date.month == session[:calendar_date].to_date.month && ev.start_date.year == session[:calendar_date].to_date.year }
    else
      @events = current_user_events.select { |ev| ev.start_date.month == Date.today.month && ev.start_date.year == Date.today.year }
    end
    @event = Event.includes(:organizer).find(params[:id])
    session[:calendar_date] = @event.start_date.to_date
  end

  def calendar_events
    @events = current_user_events.select { |ev| ev.start_date == params[:start_date].to_date }
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
