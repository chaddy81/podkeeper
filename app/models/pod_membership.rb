class PodMembership < ActiveRecord::Base
  acts_as_paranoid
  attr_accessible :pod_id, :pod, :user_id, :user, :get_ready_bar_expanded, :access_level_id, :access_level, :deleted_at, :last_visit_notes, :last_visit_events, :last_visit_lists, :last_visit_files

  belongs_to :user
  belongs_to :pod
  belongs_to :access_level
  has_many :uploaded_files, dependent: :destroy

  before_destroy :delete_invites

  scope :admin, -> { where(access_level_id: 3) }

  before_create :set_last_visits
  after_create :create_settings

  def show_get_ready_bar!
    self.update_attribute(:get_ready_bar_expanded, true)
  end

  def hide_get_ready_bar!
    self.update_attribute(:get_ready_bar_expanded, false)
  end

  def self.reset_get_ready_bar_visibility
    PodMembership.all.each do |pod_membership|
      if pod_membership.pod.created_at > 15.days.ago
        pod_membership.show_get_ready_bar!
      else
        pod_membership.hide_get_ready_bar!
      end
    end
  end

  def prep_for_destroy!
    # reset last pod visited
    self.user.record_last_pod!(nil) if self.user.last_pod_visited_id == self.pod_id
    # downgrade access level
    self.access_level = AccessLevel.member
    self.save

    events = []
    self.user.events_as_organizer.upcoming.confirmed.where(pod_id: self.pod_id).each do |event|
      event.update_attribute(:organizer_id, self.pod.organizer_id)
      events << event
    end

    EventMailer.delay.new_event_contact(events, self.pod, self.user.full_name) if events.any?
  end

  def pod_admin?
    self.access_level_id >= AccessLevel.find_by_name('pod_admin').id
  end

  def pod_admin_with_sharing?
    self.access_level_id >= AccessLevel.find_by_name('pod_admin_with_grant_option').id
  end

  def create_settings
    Setting.create!(pod_id: self.pod_id, user_id: self.user_id)
  end

  def reassign_comments(user)
    invite = Invite.where(email: user.email, pod_id: self.pod.id).first
    invite.update_attributes(accepted: false) if invite
    notes = self.pod.notes.includes(:comments).where(:comments => {user_id: user.id})
    notes.each do |note|
      note.comments.where(user_id: user.id).each do |comment|
        unless comment.invite.nil?
          comment.update_attributes(user_id: nil)
        else
          comment.update_attributes(invite_id: Invite.find_by_email(user.email).id, user_id: nil)
        end
      end
    end
  end

  def self.yesterday
    where(created_at: DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day)
  end

  def self.joined_yesterday pod, user
    where(pod_id: pod.id).where("user_id != ?", user.id).yesterday
  end

  def self.left_yesterday pod
    only_deleted.where(pod_id: pod.id).where(deleted_at: DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day)
  end

  private

  def set_last_visits
    dummy_date = DateTime.new(2000,1,1)
    self.last_visit_notes = dummy_date
    self.last_visit_events = dummy_date
    self.last_visit_lists = dummy_date
    self.last_visit_files = dummy_date
  end

  def delete_invites
    self.user.received_invites.where(pod_id: self.pod_id).destroy_all
  end

end
