class Pod < ActiveRecord::Base
  include ApplicationHelper

  attr_accessible :pod_category_id, :pod_category, :pod_sub_category_id, :pod_sub_category, :description, :invites_attributes, :name, :organizer_id, :organizer, :slug, :active, :deleted_at
  acts_as_paranoid

  belongs_to :organizer, class_name: 'User'
  belongs_to :pod_category
  belongs_to :pod_sub_category
  has_many :events, dependent: :destroy
  has_many :invalid_emails, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :kids, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :pod_memberships, dependent: :destroy
  has_many :uploaded_files, through: :pod_memberships
  has_many :users, through: :pod_memberships
  has_many :settings, dependent: :destroy
  has_one :deleted_pod_attribute
  accepts_nested_attributes_for :invites, reject_if: :any_invite_fields_blank?, allow_destroy: true

  before_create :generate_slug
  after_create :send_confirmation_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :pod_category, presence: true
  validates :pod_sub_category, presence: true, if: :validate_sub_category?
  validates :pod_category_id, presence: true
  validates :pod_sub_category_id, presence: true, if: :validate_sub_category?
  validates :slug, uniqueness: true

  def add_organizer
    self.pod_memberships.create(user_id: self.organizer_id, access_level: AccessLevel.pod_admin_with_sharing)
  end

  def to_param
    slug
  end

  def self.purge_deleted_pods_older_than_three_months
    pods = Pod.only_deleted.where('deleted_at < ?', 3.months.ago).destroy_all
  end

  def save_pod_attributes(deleter)
    number_of_comments = 0
    self.notes.each do |note|
      number_of_comments += note.comments.count
    end

    DeletedPodAttribute.create!(creator: self.organizer,
                                deleter: deleter,
                                number_of_comments: number_of_comments,
                                number_of_discussions: self.notes.count,
                                number_of_documents: 0,
                                number_of_members: self.users.count,
                                number_of_open_invites: self.invites.unaccepted.count,
                                number_of_past_events: self.events.where(completed: true).count,
                                number_of_pod_admins: 1,
                                number_of_task_lists: 0,
                                number_of_tasks: 0,
                                number_of_upcoming_events: self.events.where(completed: false).count,
                                pod_created_at: self.created_at,
                                pod_deleted_at: DateTime.now,
                                pod_name: self.name,
                                pod_id: self.id)
  end

  def admin?(user)
    pod_memberships = self.pod_memberships.where(user_id: user.id)
    pod_memberships.any? && pod_memberships.last.access_level_id  && pod_memberships.last.access_level_id >= AccessLevel.pod_admin.id
  end

  def require_rsvp(user)
    user_rsvp = []

    self.events.upcoming.where(require_rsvp: true).each do |event|
      if user.rsvps
        rsvp = user.rsvps.where(event_id: event.id).last
        if rsvp.rsvp_option.nil?
          user_rsvp << event
        end
      end
    end
    user_rsvp
  end

  def active_discussion
    Comment.unscoped.group('date(created_at), note_id').
      select('date(created_at) as created_date, count(id) as comment_count, note_id').
      where(note_id: self.notes.pluck(:id)).order('created_date, comment_count desc').first.try(:note)
  end

  private

  def send_confirmation_email
    PodMailer.delay.pod_creation_confirmation(self)
  end

  def any_invite_fields_blank?(attributes)
    attributes[:email].blank? &&
    attributes[:first_name].blank? &&
    attributes[:last_name].blank?
  end

  def validate_sub_category?
    return false if pod_category.nil?
    pod_category.name == 'sports' || pod_category.name == 'arts_music' || pod_category.name == 'parents_activity'
  end

  def generate_slug
    # if slug exists - tack on a number
    if Pod.with_deleted.find_by_slug(name.parameterize)
      count = 1
      slug = "#{count}-#{name.parameterize}"
      while Pod.with_deleted.find_by_slug(slug)
        count = count + 1
        slug = "#{count}-#{name.parameterize}"
      end
      self.slug = slug
    else
      self.slug = name.parameterize
    end
  end

end
