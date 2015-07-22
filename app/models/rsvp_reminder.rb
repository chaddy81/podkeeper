class RsvpReminder < ActiveRecord::Base
  attr_accessible :days_before, :event_id, :event

  belongs_to :event

  validates :days_before, presence: true, numericality: { only_integer: true }
end
