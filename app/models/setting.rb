class Setting < ActiveRecord::Base
  attr_accessible :note_new_notice, :note_reply_to_you_notice, :note_reply_to_any_notice, :event_new_notice,
    :event_update_notice, :event_reminder_notice, :note_urgent_notice, :pod_id, :pod, :user_id, :user

  belongs_to :user
  belongs_to :pod

  validates :user_id, presence: true
  validates :pod_id,  presence: true
end
