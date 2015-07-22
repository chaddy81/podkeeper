class Invite < ActiveRecord::Base
  attr_accessible :email, :first_name, :invitee_id, :invitee, :inviter_id, :inviter, :last_name, :pod_id, :pod, :pod_name, :accepted, :declined

  belongs_to :pod
  belongs_to :invitee, class_name: 'User'
  belongs_to :inviter, class_name: 'User'
  has_many   :reminders, dependent: :destroy
  has_many   :comments,  dependent: :destroy

  validates :email, presence: true,
                    format:   { with: VALID_EMAIL_REGEX }

  validate :ensure_user_is_not_already_in_pod, on: :create
  validate :ensure_invite_is_unique, on: :create

  before_create :generate_token, :assign_user_if_registered
  before_validation :downcase_email, :strip_whitespace

  scope :accepted,   -> { where(accepted: true) }
  scope :unaccepted, -> { where(accepted: false, declined: false) }
  scope :declined,   -> { where(declined: true) }

  def downcase_email
    self.email.downcase! if self.email.present?
  end

  def assign_user_if_registered
    self.invitee = User.find_by_email(self.email)
  end

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      email
    end
  end

  def accept!
    self.update_attribute(:accepted, true)
  end

  def decline!
    self.update_attribute(:declined, true)
  end

  def self.today
    where("created_at >= ?", Time.now.beginning_of_day.in_time_zone)
  end

  def self.declined_yesterday pod
    where(pod_id: pod.id, declined: true).where(updated_at: DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day)
  end

  private

  def ensure_invite_is_unique
    invites = Invite.where(email: self.email, pod_id: self.pod_id)
    if invites.any? && invites.first.pod.present?
      errors.add(:email, 'has already been invited. You can send them a reminder if you want.')
    end
  end

  def ensure_user_is_not_already_in_pod
    self.assign_user_if_registered
    if self.pod.present? && self.invitee.present?
      if self.pod.pod_memberships.pluck(:user_id).include?(self.invitee.id)
        errors.add(:email, 'is already a member of the pod')
      end
    end
  end

  def generate_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def strip_whitespace
    self.first_name = self.first_name.strip unless self.first_name.nil?
    self.last_name = self.last_name.strip unless self.last_name.nil?
  end

end
