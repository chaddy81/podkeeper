class Comment < ActiveRecord::Base
  attr_accessible :body, :note_id, :note, :user_id, :invite_id, :user

  validates :body,    presence: true
  validates :note_id, presence: true
  validates :user_id, presence: true, :if => lambda { self.invite_id.blank? }
  validates :invite_id, presence: true, :if => lambda { self.user_id.blank? }

  default_scope -> { order('created_at desc') }

  belongs_to :user
  belongs_to :invite
  belongs_to :note

  after_create :send_notification
  after_save :update_note_timestamp_for_sorting

  def convert_to_user_comment user_id
    self.update_attributes(user_id: user_id)
  end

  def convert_to_invite_comment
    self.update_attributes(user_id: nil)
  end

  private

  def send_notification
    Notifications.new.reply_to_my_note(self)
  end

  def update_note_timestamp_for_sorting
    self.note.update_sort_by_date
  end

end
