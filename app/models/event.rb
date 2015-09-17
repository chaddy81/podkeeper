class Event < ActiveRecord::Base
  extend SimpleCalendar
  has_calendar attribute: :start_date

  attr_accessible :city, :completed, :description, :end_date, :end_time, :location, :name, :notify_members_of_update,
                  :organizer_id, :organizer, :phone, :pod_id, :pod, :require_rsvp, :start_date, :start_time, :state, :street,
                  :zipcode, :time_zone, :confirmed, :confirmed_at, :notes, :custom_reminders_specified, :event_reminders_attributes,
                  :rsvp_reminders_attributes, :old_event, :neID, :single_event, :weeks

  attr_accessor :notify_members_of_update, :custom_reminders_specified, :event_editing, :old_event, :neID

  belongs_to :organizer, class_name: 'User'
  belongs_to :pod

  has_many :rsvps, dependent: :destroy
  has_many :users, through: :rsvps
  has_many :rsvp_reminders, dependent: :destroy
  has_many :event_reminders, dependent: :destroy

  accepts_nested_attributes_for :rsvp_reminders, allow_destroy: true
  accepts_nested_attributes_for :event_reminders, allow_destroy: true

  scope :past,      -> { where(completed: true) }
  scope :upcoming,  -> { where(completed: false) }
  scope :confirmed, -> { where(confirmed: true) }
  scope :requires_rsvp, -> { where(require_rsvp: true) }
  scope :updated_yesterday, -> { where(created_at: DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day) }
  scope :updated_three_days_ago, -> { where(created_at: (DateTime.now-3.days)..DateTime.yesterday.end_of_day) }
  scope :created_in_last_three_days, -> { where(confirmed_at: (DateTime.now.beginning_of_day-2.days)..DateTime.now.end_of_day) }

  validates :name,        presence: true, length: { maximum: 40 }
  validates :location,    presence: true
  validates :phone,       length: { is: 12, message: 'is the wrong length (should be 10 digits)' },
                          allow_blank: true
  validates :start_date,  presence: true
  validates :end_date,    presence: true, if: :end_time?
  validates :start_time,  presence: true
  validates :end_time,    presence: true, if: :end_date?
  validates :time_zone,   presence: true
  validates :zipcode,     length: { is: 5 }, allow_blank: true
  validates :pod_id,      presence: true

  validate :start_time_is_not_in_the_past
  validate :end_time_is_later_than_start_time
  validate :must_be_unique
  validate :no_duplicate_reminders

  def address
    return self.address_without_street if self.street.blank?
    "#{self.street}, #{self.address_without_street}"
  end

  def address_without_street
    "#{self.city}#{', ' if self.city.present?}#{self.state} #{self.zipcode}"
  end

  def self.mark_events_as_complete
    events = Event.confirmed.upcoming
    events.each do |event|
      if event.end_date.nil?
        event.update_attribute(:completed, true) if event.start_date_time + 1.day <= 12.hours.ago
      else
        event.update_attribute(:completed, true) if event.end_date_time + 1.day <= 12.hours.ago
      end
    end
  end

  def gmaps_address
    return '' if self.street.blank? || self.city.blank? || self.state.blank? || self.zipcode.blank?
    self.address
  end

  def start_date_time
    merge_date_time(self.start_date, self.start_time.in_time_zone)
  end

  def end_date_time
    if self.end_date.nil?
      self.start_date_time
    else
      merge_date_time(self.end_date, self.end_time.in_time_zone)
    end
  end

  def adjust_for_time_zone!
    self.start_time = self.start_time.change(month: 1, day: 1, year: 2000) unless self.start_time.nil?
    self.end_time =   self.end_time.change(month: 1, day: 1, year: 2000) unless self.end_time.nil?
  end

  def confirm!
    self.confirmed = true
    self.confirmed_at = DateTime.now
    self.save(validate: false)
  end

  def self.today(user)
    where("created_at >= ?", Time.now.beginning_of_day.in_time_zone(user.time_zone))
  end

  private

  def merge_date_time(date, time)
    DateTime.new(date.year, date.month,
                 date.day, time.hour,
                 time.min, time.sec)
  end

  def end_time_is_later_than_start_time
    return true if end_date.nil? || start_date.nil?

    if start_date > end_date
      errors.add(:end_date, 'must be later than start date')
    end

    if start_date == end_date
      errors.add(:end_time, 'must be later than start time') if end_time.present? && end_time < start_time
    end
  end

  def start_time_is_not_in_the_past
    return unless start_date.present?
    todays_date = Time.now.in_time_zone(time_zone).to_date
    if start_date < todays_date
      errors.add(:start_date, 'cannot be in the past')
    elsif start_date == todays_date
      errors.add(:start_time, 'cannot be in the past') if start_time < (Time.now.utc + start_time.in_time_zone(time_zone).utc_offset).change(month: 1, day: 1, year: 2000)
    end
  end

  def must_be_unique
    events = self.pod.events.confirmed.upcoming.where(self.attributes.select { |key, _| ['name', 'location', 'start_date', 'end_date', 'end_time'].include? key })

    events = events.where(end_time: self.end_time.change(month: 1, day: 1, year: 2000)) unless self.end_time.nil?
    events = events.where(start_time: self.start_time.change(month: 1, day: 1, year: 2000)) unless self.start_time.nil?
    if events.any?
      errors.add(:base, 'An identical event already exists. You must change at least 1 of these: Event Name, Location Name, Date, Time.')
      false
    end
  end

  def no_duplicate_reminders
    rsvp_reminders_days =  self.rsvp_reminders.reject(&:marked_for_destruction?).map { |r| r.days_before }
    event_reminders_days = self.event_reminders.reject(&:marked_for_destruction?).map { |r| r.days_before }
    if rsvp_reminders_days.length != rsvp_reminders_days.uniq.length || event_reminders_days.length != event_reminders_days.uniq.length
      errors.add(:base, 'You cannot have the same reminder go out more than once a day.')
      false
    end
  end

end
