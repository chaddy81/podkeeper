class Note < ActiveRecord::Base
  attr_accessible :body, :event_id, :event, :is_urgent, :pod_id, :pod, :topic, :user_id, :user, :sort_by_date, :token, :comment_id
  attr_reader :body_count, :topic_count

  belongs_to :event
  belongs_to :pod
  belongs_to :user
  has_many :comments, dependent: :destroy

  scope :urgent, -> {
                   where(is_urgent: true)
                  .order('sort_by_date')
                  .includes(:comments, comments: :user)
                }
  scope :regular, -> {
                  where(is_urgent: false)
                  .order('sort_by_date')
                  .includes(:comments, comments: :user)
                }
  scope :updated_yesterday, -> { where(created_at: DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day) }

  # default_scope -> { includes(:comments, comments: :user) }

  validates :topic,   presence: true, length: { maximum: 60 }
  validates :body,    presence: true, length: { maximum: 2000 }
  validates :user_id, presence: true

  before_create :generate_token

  after_create :send_notifications

  def update_sort_by_date
    self.update_column(:sort_by_date, DateTime.now)
  end

  def generate_token
    begin
        token = SecureRandom.hex(11)
    end while Note.where(token: token).exists?
    self.token = token
  end

  private

  def send_notifications
    if is_urgent?
      Notifications.new.urgent_note_posted(self)
    else
      Notifications.new.note_posted(self)
    end
  end

end
