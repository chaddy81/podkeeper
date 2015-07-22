class Rsvp < ActiveRecord::Base
  attr_accessible :comments, :event_id, :event, :number_of_adults, :number_of_kids, :rsvp_option_id, :rsvp_option, :user_id, :user

  validates :event_id,         presence: true
  validates :user_id,          presence: true
  validates :rsvp_option_id,   presence: true
  validates :number_of_kids, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99 }, allow_blank: true
  validates :number_of_adults, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99 }, allow_blank: true

  validate :at_least_one_person_is_attending, unless: :rsvp_option_is_no?

  belongs_to :user
  belongs_to :event
  belongs_to :rsvp_option

  before_save :default_attendees_to_zero

  def rsvp_option_is_no?
    rsvp_option_id == RsvpOption.no.id
  end

  def self.accepted
    self.where(rsvp_option_id: RsvpOption.yes.id)
  end

  def self.rejected
    self.where(rsvp_option_id: RsvpOption.no.id)
  end

  def self.undecided
    self.where(rsvp_option_id: RsvpOption.maybe.id)
  end

  private

  def default_attendees_to_zero
    self.number_of_kids = 0 if self.number_of_kids.nil?
    self.number_of_adults = 0 if self.number_of_adults.nil?
  end

  def at_least_one_person_is_attending
    if (number_of_kids.nil? || number_of_kids == 0) && (number_of_adults.nil? || number_of_adults == 0)
      errors.add(:base, 'You must select at least one person to attend.')
    end
  end

end
