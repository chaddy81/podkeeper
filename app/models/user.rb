class User < ActiveRecord::Base
  attr_accessible :active, :emails_attributes, :first_name, :email, :is_admin, :last_login, :last_name, :password, :password_confirmation, :phone,
    :remember_me, :pod_id, :time_zone, :testing_password, :testing_password_confirmation, :last_pod_visited_id, :invite_id, :daily_digest,
    :provider, :uid, :name, :oauth_token, :oauth_expires_at

  attr_accessor :remember_me, :testing_password, :testing_password_confirmation, :pod_id, :invite_id

  has_many :settings, -> { order('pod_id') }, dependent: :destroy
  has_many :comments,        dependent: :destroy
  has_many :deleted_pod_attributes_as_creator, foreign_key: 'creator_id', class_name: 'DeletedPodAttribute'
  has_many :deleted_pod_attributes_as_deleter, foreign_key: 'deleter_id', class_name: 'DeletedPodAttribute'
  has_many :kids,            dependent: :destroy
  has_many :lists,           foreign_key: 'creator_id'
  has_many :list_items,      dependent: :destroy
  has_many :notes,           dependent: :destroy
  has_many :pod_memberships, dependent: :destroy
  has_many :rsvps,           dependent: :destroy
  has_many :site_comments,   dependent: :destroy
  has_many :pods_as_organizer,   foreign_key: 'organizer_id', class_name: 'Pod'
  has_many :events_as_organizer, foreign_key: 'organizer_id', class_name: 'Event'
  has_many :sent_invites,        foreign_key: 'inviter_id',   class_name: 'Invite'
  has_many :received_invites,    foreign_key: 'invitee_id',   class_name: 'Invite'
  has_many :events, through: :rsvps
  has_many :pods,   through: :pod_memberships
  has_many :invalid_emails, dependent: :destroy

  has_secure_password

  before_create :generate_token, :capitalize_names, :set_names_if_blank
  after_create  :assign_invites
  before_validation :downcase_email

  validates :first_name, presence: true, allow_blank: true
  validates :last_name,  presence: true, allow_blank: true
  validates :phone,      length: { is: 12, message: 'is the wrong length (should be 10 digits)' }, allow_blank: true
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  validates :time_zone,  presence: true
  validates :password, length: { minimum: 6, maximum: 128, allow_blank: true }, if: :test_password?
  validates :password_confirmation, length: { minimum: 6, maximum: 128, allow_blank: true }, if: :test_password_confirmation?
  # validates :password_confirmation, length: { minimum: 6, maximum: 128 }, allow_blank: true

  def default_email
    self.emails.where(default: true).first
  end

  def send_password_reset
    self.update_attribute :password_reset_token, SecureRandom.urlsafe_base64
    self.update_attribute :password_reset_sent_at, Time.zone.now
    UserMailer.password_reset(self).deliver
  end

  def full_name
    # "#{self.first_name} #{self.last_name}"
    self.first_name? ? "#{self.first_name} #{self.last_name}" : self.email
  end

  def record_last_pod!(pod_id)
    self.update_attribute(:last_pod_visited_id, pod_id)
  end

  # assigns all invoices for users email address to the user specifically
  def assign_invites(email=nil)
    email ||= self.email
    invites = Invite.where(email: email)
    invites.each do |invite|
      invite.update_attribute(:invitee_id, self.id)
      invite.update_attribute(:accepted, true) if invite.pod.nil?
    end
  end

  def events_without_rsvp(pod)
    pod.events.include(:rspvs).where('rsvps.user_id != ?', self.id).references(:rspvs)
  end

  def new_discussions(pod)
    last_visit = self.pod_memberships.where(pod_id: pod.id).first.last_visit_notes
    pod.notes.where('created_at > ? and user_id != ?', last_visit, self.id).count
  end

  def new_events(pod)
    last_visit = self.pod_memberships.where(pod_id: pod.id).first.last_visit_events
    pod.events.upcoming.where('created_at > ? and organizer_id != ?', last_visit, self.id).count
  end

  def new_lists(pod)
    last_visit = self.pod_memberships.where(pod_id: pod.id).first.last_visit_lists
    pod.lists.where('created_at > ? and creator_id != ?', last_visit, self.id).count
  end

  def new_files(pod)
    last_visit = self.pod_memberships.where(pod_id: pod.id).first.last_visit_files
    user_count = 0
    pod.uploaded_files.where('uploaded_files.created_at > ?', last_visit).each do |file|
      if file.pod_membership.user == self
        user_count += 1
      end
    end
    total_count = pod.uploaded_files.where('uploaded_files.created_at > ?', last_visit).count

    return total_count - user_count
  end

  def update_last_visit(pod, section)
    attr = { section => DateTime.now }
    self.pod_memberships.where(pod_id: pod.id).first.update_attributes attr
  end

  def update_omniauth auth
    self.update_columns(provider: auth.provider, uid: auth.uid,
          oauth_token: auth.credentials.token, oauth_expires_at: Time.at(auth.credentials.expires_at))
    if self.first_name.blank? || self.last_name.blank?
      self.update_columns(first_name: auth.info.first_name, last_name: auth.info.last_name)
    end
  end

  def self.from_omniauth(auth)
    self.where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.password = user.password_confirmation = SecureRandom.hex(12)
      user.time_zone = "none"
      user.save!
    end
  end

  private

  def generate_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def downcase_email
    self.email.downcase! if self.email.present?
  end

  def test_password?
    testing_password
  end

  def test_password_confirmation?
    testing_password_confirmation
  end

  def capitalize_names
    self.first_name = self.first_name.split(' ').map(&:capitalize).join(' ') if self.first_name
    self.last_name = self.last_name.split(' ').map(&:capitalize).join(' ') if self.last_name
  end

  def set_names_if_blank
    self.first_name = '' if self.first_name == nil
    self.last_name  = '' if self.last_name  == nil
  end

end
