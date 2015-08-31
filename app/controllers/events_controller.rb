class EventsController < ApplicationController
  before_filter :user_belongs_to_pod?, only: :show
  before_filter :can_create?, only: :new
  before_filter :is_organizer?, only: [:edit, :update]
  before_filter :event_has_not_been_completed, only: [:edit, :update, :destroy]
  before_filter :get_pod

  include Icalendar

  def index
    @events = current_pod.events.confirmed.where(completed: completed).order('start_date ASC').order('start_time ASC')
  end

  def new
    six_oclock_gmt = '06:00 PM'
    @event = current_user.events_as_organizer.new
    @event.start_time = six_oclock_gmt
    @event.time_zone = current_user.time_zone
    @event.pod_id = current_pod.id

    @event.rsvp_reminders.new(days_before: 14)
    @event.rsvp_reminders.new(days_before: 4)
    @event.event_reminders.new(days_before: 7)
    @event.event_reminders.new(days_before: 1)
    # end
  end

  def create
    @event = current_user.events_as_organizer.new(params[:event])
    @event.time_zone = current_user.time_zone
    @event.pod_id = current_pod.id

    @event.event_editing = true
    if @event.save
      @event.adjust_for_time_zone!
      @event.confirm!

      if params[:event][:require_rsvp] == "1" && params[:event][:rsvp_reminders_attributes].present?
        @event.rsvp_reminders.destroy_all
        params[:event][:rsvp_reminders_attributes].each do |key,value|
          if value['_destroy'] == 'false'
            @event.rsvp_reminders.create(days_before: value['days_before'])
          end
        end
      end

      if params[:event][:event_reminders_attributes].present?
        @event.event_reminders.destroy_all
        params[:event][:event_reminders_attributes].each do |key,value|
          if value['_destroy'] == 'false'
            @event.event_reminders.create(days_before: value['days_before'])
          end
        end
      end

      unless @event.single_event
        (1...@event.weeks).each do |i|
          event = @event.dup

          rsvp_reminders = @event.rsvp_reminders
          event_reminders = @event.event_reminders

          event.start_date = event.start_date + i.weeks
          if event.end_date
            event.end_date = event.end_date + i.weeks
          end

          event.save
          event.confirm!

          rsvp_reminders.each do |rsvp|
            new_rsvp = rsvp.dup
            new_rsvp.event_id = event.id
            new_rsvp.save
          end

          event_reminders.each do |ev|
            new_event = ev.dup
            new_event.event_id = event.id
            new_event.save
          end
        end
      end

      # send notification to all pod members
      @event.pod.users.each do |user|
        if user.settings.where(pod_id: @event.pod.id).last.event_new_notice == true
          EventMailer.delay.new_event(@event, user)
        end
      end

      # send notification to all non-pod members
      @event.pod.invites.unaccepted.each do |invite|
        EventMailer.delay.new_event_non_member(invite, @event)
      end

      if @event.require_rsvp?
        if @event.single_event
          flash[:success] = 'Your event has been created successfully! Be sure to RSVP'
        else
          flash[:success] = "Your Weekly Series of Events has been created successfully! Be sure to RSVP"
        end
      else
        @event.rsvp_reminders.destroy_all
        flash[:success] = 'Your event has been created successfully!'
      end

      redirect_to event_path(@event)
    else
      flash[:error] = @event.errors.full_messages.first
      render :new
    end
  end

  def edit
    @event.notify_members_of_update = true
    @rsvp_options = RsvpOption.all
    @event_note = EventNote.new
    # adjust start dates from current users time zone to event time zone
    @event.start_time = @event.start_time - (@event.start_time.in_time_zone(current_user.time_zone).utc_offset - @event.start_time.in_time_zone(@event.time_zone).utc_offset)
    @event.end_time = @event.end_time - (@event.end_time.in_time_zone(current_user.time_zone).utc_offset - @event.end_time.in_time_zone(@event.time_zone).utc_offset) if @event.end_time.present?
  end

  def update
    referrer = Rails.application.routes.recognize_path(request.referrer)

    Time.zone = params[:event][:time_zone]
    if @event.confirmed?

      @event.event_editing = true

      if @event.update_attributes(params[:event])

        @event.adjust_for_time_zone!
        @event.save
        if @event.notify_members_of_update.to_i > 0
          @event.pod.users.each do |user|
            if user.settings.where(pod_id: @event.pod.id).last.event_update_notice == true
              EventMailer.delay.event_updated(user, @event) unless current_user?(user)
            end
          end

          @event.pod.invites.unaccepted.each do |invite|
            EventMailer.delay.event_updated_to_non_member(invite, @event)
          end
        end
        @event.rsvps.destroy_all unless @event.require_rsvp
        flash[:success] = 'Your event has been updated successfully!'
        redirect_to event_path(@event)
      else
        @event.adjust_for_time_zone!
        flash[:error] = @event.errors.full_messages.first
        render :edit
      end
    else
      if @event.update_attributes(params[:event])
        @event.adjust_for_time_zone!

        @event.save
        redirect_to event_review_path(@event)
      else
        if params[:event][:require_rsvp] == "1" && params[:event][:rsvp_reminders_attributes].present?
          @event.rsvp_reminders.destroy_all
          params[:event][:rsvp_reminders_attributes].each do |key,value|
            if value['_destroy'] == 'false'
              @event.rsvp_reminders.create(days_before: value['days_before'])
            end
          end
        end

        if params[:event][:event_reminders_attributes].present?
          @event.event_reminders.destroy_all
          params[:event][:event_reminders_attributes].each do |key,value|
            if value['_destroy'] == 'false'
              @event.event_reminders.create(days_before: value['days_before'])
            end
          end
        end

        @event.adjust_for_time_zone!
        flash[:error] = @event.errors.full_messages.first
        render :new
      end
    end
  end

  def show
    @events = @pod.events.confirmed.where(completed: completed).includes(:organizer, :pod, :rsvps, pod: :organizer).order('start_date ASC').order('start_time ASC')
    @event = ::Event.includes(:organizer).find(params[:id])
    if current_pod != @event.pod
      set_current_pod(@event.pod)
    #   redirect_to event_path(@active_event) and return
    end
    # @events = current_pod.events.where(completed: @active_event.completed).confirmed.includes(:organizer, :pod, pod: :organizer).order('start_date ASC').order('start_time ASC')
    # render :index
  end

  def destroy
    @event = ::Event.find(params[:id])
    @event.pod.users.each do |user|
      EventMailer.delay.cancelled(@event, user)
    end

    @event.pod.invites.unaccepted.each do |invite|
      EventMailer.delay.cancelled(@event, invite)
    end

    @event.destroy
    flash[:success] = 'Event was deleted successfully!'
    redirect_to events_path
  end

  def cancel
    @event = ::Event.find(params[:event_id])
    render_404 and return if @event.completed?
  end

  def edit_notes
    @event = ::Event.find(params[:id])
    @edit_note = true
    render :notes_form
  end

  def update_notes
    @event = ::Event.find(params[:id])
    @event.update_column(:notes, params[:event][:notes])
    render :notes_form
  end

  def cancel_notes_editing
    @event = ::Event.find(params[:id])
    render :notes_form
  end

  def duplicate
    @neID = params[:neID]
    @new_event = ::Event.find_by_id(@neID)
    @old_event = ::Event.find_by_id(params[:event_id])

    render_404 and return unless current_user.pods.include?(@old_event.pod)

    unless @new_event.blank?
      @event = @new_event
    else
      events = current_user.events_as_organizer.where(confirmed: false, completed: false, pod_id: current_pod.id)
      if events.any?
        @event = events.last
      else
        @event = ::Event.new
      end

      @event.start_date =   @old_event.start_date
      @event.end_date =     @old_event.end_date
      @event.start_time =   @old_event.start_time - (@old_event.start_time.in_time_zone(current_user.time_zone).utc_offset - @old_event.start_time.in_time_zone(@old_event.time_zone).utc_offset)
      if @old_event.end_time.present?
        @event.end_time =   @old_event.end_time - (@old_event.end_time.in_time_zone(current_user.time_zone).utc_offset - @old_event.end_time.in_time_zone(@old_event.time_zone).utc_offset)
      else
        @event.end_time = nil
      end
      @event.city =         @old_event.city
      @event.description =  @old_event.description
      @event.location =     @old_event.location
      @event.name =         @old_event.name
      @event.phone =        @old_event.phone
      @event.pod_id =       @old_event.pod_id
      @event.require_rsvp = @old_event.require_rsvp
      @event.state =        @old_event.state
      @event.street =       @old_event.street
      @event.zipcode =      @old_event.zipcode
      @event.time_zone =    @old_event.time_zone
      @event.organizer =    current_user

      @event.save(validate: false)

      @event.rsvp_reminders.destroy_all
      @event.event_reminders.destroy_all

      @old_event.rsvp_reminders.each do |rsvp|
        @event.rsvp_reminders.create(days_before: rsvp.days_before)
      end

      @old_event.event_reminders.each do |event|
        @event.event_reminders.create(days_before: event.days_before)
      end
    end
    # render :new, :params => { :duplicate => true }
  end

  def update_duplicate
    @event = ::Event.find_by_id(params[:event][:old_event])
    new_event = ::Event.find(params[:id])

    new_event.attributes = params[:event].except(:custom_reminders_specified, :rsvp_reminders_attributes, :event_reminders_attributes, :notify_members_of_update)

    if params[:event][:require_rsvp] == "1" && params[:event][:rsvp_reminders_attributes].present?
      new_event.rsvp_reminders.destroy_all
      params[:event][:rsvp_reminders_attributes].each do |key,value|
        puts value
        if value['_destroy'] == 'false'
          new_event.rsvp_reminders.create(days_before: value['days_before'])
        end
      end
    end

    if params[:event][:event_reminders_attributes].present?
      new_event.event_reminders.destroy_all
      params[:event][:event_reminders_attributes].each do |key,value|
        if value['_destroy'] == 'false'
          new_event.event_reminders.create(days_before: value['days_before'])
        end
      end
    end

    new_event.adjust_for_time_zone!

    new_event.save(validate:false)

    comparison = @event.attributes.except('id', 'created_at', 'updated_at', 'confirmed', 'confirmed_at') == new_event.attributes.except('id', 'created_at', 'updated_at', 'confirmed', 'confirmed_at')

    if comparison == true
      flash[:error] = 'You haven\'t made any changes or additions'
      redirect_to event_duplicate_path(@event, neID: new_event.id)
    else
      if new_event.save
        new_event.adjust_for_time_zone!
        new_event.confirm!

        if new_event.require_rsvp?
          flash[:success] = 'Your event has been created successfully! Be sure to RSVP'
        else
          new_event.rsvp_reminders.destroy_all
          flash[:success] = 'Your event has been created successfully!'
        end

        redirect_to event_path(new_event)
      else
        flash.keep[:error] = new_event.errors.full_messages.first
        redirect_to event_duplicate_path(@event, neID: new_event.id)
      end
    end
  end

  def sort
    if params[:column] == 'status'
      # Order is: Yes, No, Maybe, Not Yet Replied, No RSVP Required.
      event_ids = current_pod.events.confirmed.where(completed: completed).pluck(:id)
      rsvps = current_user.rsvps.where('event_id in (?)', event_ids)

      with_rsvp_yes = rsvps.where(rsvp_option_id: RsvpOption.yes.id)
      with_rsvp_no = rsvps.where(rsvp_option_id: RsvpOption.no.id)
      with_rsvp_maybe = rsvps.where(rsvp_option_id: RsvpOption.maybe.id)

      @events = []
      [with_rsvp_yes, with_rsvp_no, with_rsvp_maybe].each do |rsvps|
        rsvps.each do |rsvp|
          @events << rsvp.event
        end
      end

      where_rsvp_not_specified = current_pod.events.confirmed.where(completed: completed, require_rsvp: true).reject { |e| current_user.rsvps.where(event_id: e.id).any? }
      without_rsvp = current_pod.events.confirmed.where(completed: completed, require_rsvp: false)

      @events += where_rsvp_not_specified + without_rsvp
      @events.reverse! if params[:direction] == 'asc'
    elsif params[:column] == 'name'
      @events = current_pod.events.confirmed.where(completed: completed).includes(:organizer).order("#{params[:column]} #{'desc' unless params[:direction] == 'desc'}")
    elsif params[:column] == 'start_date_time'
      @events = current_pod.events.confirmed.where(completed: completed).includes(:organizer)
      @events.sort_by! { |e| e.start_date_time }
      @events.reverse! if params[:direction] == 'asc'
    else
      @events = current_pod.events.confirmed.where(completed: completed).includes(:organizer).order("#{params[:column]} #{params[:direction]}")
    end
  end

  def export_to_personal_calendar
    @event = ::Event.find(params[:event_id])
  end

  def export_to_ical
    @event = ::Event.find(params[:event_id])
    podanize_event = @event.dup

    cal = Icalendar::Calendar.new
    cal.event do |e|
      e.dtstart     = podanize_event.start_date_time
      e.dtend       = podanize_event.end_date_time
      e.location    = "#{podanize_event.location}#{' - ' unless podanize_event.address.blank?}#{podanize_event.address}"
      e.summary     = podanize_event.name
      e.description = podanize_event.description
      e.url         = 'http://www.podkeeper.com'
      e.organizer   = podanize_event.organizer.email
    end

    send_data cal.to_ical,
      filename: 'event.ics',
      type: 'text/calendar'
  end

  def update_last_visit
    current_user.update_last_visit(current_pod, :last_visit_events)
    render nothing: true, status: 200
  end

  def clear_fields
    @event = ::Event.find(params[:event_id])
    @event.destroy
    redirect_to new_event_path
  end

  def calendar_events
    @events = current_pod.events.confirmed.where(start_date: params[:start_date]).includes(:organizer, :pod, :rsvps, pod: :organizer).order('start_date ASC').order('start_time ASC')
  end

  private

  def can_create?
    pod = Pod.find(current_pod.id)
    render_404 unless current_user.pods.include?(pod)
  end

  def user_belongs_to_pod?
    @event = ::Event.find(params[:id])
    render_404 unless current_user.pods.include?(@event.pod)
  end

  def is_organizer?
    @event = ::Event.find(params[:id])
    render_404 unless current_user?(@event.organizer) || is_at_least_pod_admin?
  end

  def completed
    params[:completed] == 'true'
  end

  def event_has_not_been_completed
    @event = ::Event.find(params[:id])
    render_404 and return if @event.completed?
  end

  def get_pod
    if params[:pod_id]
      set_current_pod current_user.pods.where(id: params[:pod_id]).first
    end
    @pod = current_pod
  end

end
