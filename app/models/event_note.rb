class EventNote

  include ActiveModel::Model
  include ActiveModel::Associations

  attr_accessor :note, :havent_responded, :rsvp_yes, :rsvp_no, :rsvp_maybe, :all_pod_members, :all_except_no_responses, :event_id

  # column :note, :string
  # column :havent_responded, :string
  # column :rsvp_yes, :string
  # column :rsvp_no, :string
  # column :rsvp_maybe, :string
  # column :all_pod_members, :boolean
  # column :all_except_no_responses, :boolean
  # column :event_id, :boolean

  validates :note, presence: true
  validate :must_send_to_at_least_one_group

  def must_send_to_at_least_one_group
    if rsvp_yes.to_i < 1 && rsvp_no.to_i < 1 && rsvp_maybe.to_i < 1 && havent_responded.to_i < 1 && all_pod_members.to_i < 1 && all_except_no_responses.to_i < 1
      errors.add(:base, 'You must select who the note is being sent to')
    end
  end

end
