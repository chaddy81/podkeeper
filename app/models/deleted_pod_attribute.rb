class DeletedPodAttribute < ActiveRecord::Base
  attr_accessible :creator_first_name, :creator_id, :creator, :creator_last_name, :deleter_first_name, :deleter_id, :deleter,
                  :deleter_last_name, :number_of_comments, :number_of_discussions, :number_of_documents, :number_of_members,
                  :number_of_open_invites, :number_of_past_events, :number_of_pod_admins, :number_of_task_lists,
                  :number_of_tasks, :number_of_upcoming_events, :pod_created_at, :pod_deleted_at, :pod_name, :pod_id, :pod

  belongs_to :creator, class_name: 'User'
  belongs_to :deleter, class_name: 'User'
  belongs_to :pod

  validates :pod_name, presence: true
  validates :creator,  presence: true
  validates :deleter,  presence: true

  validates :number_of_comments,        numericality: { only_integer: true }, allow_blank: true
  validates :number_of_discussions,     numericality: { only_integer: true }, allow_blank: true
  validates :number_of_documents,       numericality: { only_integer: true }, allow_blank: true
  validates :number_of_members,         numericality: { only_integer: true }, allow_blank: true
  validates :number_of_open_invites,    numericality: { only_integer: true }, allow_blank: true
  validates :number_of_past_events,     numericality: { only_integer: true }, allow_blank: true
  validates :number_of_upcoming_events, numericality: { only_integer: true }, allow_blank: true
  validates :number_of_pod_admins,      numericality: { only_integer: true }, allow_blank: true
  validates :number_of_task_lists,      numericality: { only_integer: true }, allow_blank: true
  validates :number_of_tasks,           numericality: { only_integer: true }, allow_blank: true

  before_save :set_attributes

  private

  def set_attributes
    self.creator_first_name = self.creator.first_name
    self.creator_last_name = self.creator.last_name
    self.deleter_first_name = self.deleter.first_name
    self.deleter_last_name = self.deleter.last_name
  end

end
