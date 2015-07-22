require 'file_size_validator'
class UploadedFile < ActiveRecord::Base
  attr_accessible :description, :file, :url, :pod_membership_id, :pod_membership, :file_cache, :remote_file_url

  mount_uploader :file, FileUploader

  belongs_to :pod_membership

  before_create :assign_default_description

  scope :updated_yesterday, -> { where(created_at: DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day) }

  validates :pod_membership, presence: true
  validates :file, file_size: { maximum: 5.megabytes.to_i }, on: :create
  validate :one_gig_max_storage_per_pod, on: :create

  default_scope -> { order('id DESC') }

  # hack for namespace conflict
  def identifier
    if self.file.current_path.nil? || self.file.current_path.split('/').last == 'unnamed'
      ' '
    else
      self.file.current_path.split('/').last
    end
  end

  def self.total_storage_taken_for_pod(pod)
    uploaded_files = UploadedFile.unscoped.includes(:pod_membership).where(pod_memberships: { pod_id: pod.id })
    total_size = 0

    uploaded_files.each do |uploaded_file|
      if uploaded_file.file.present?
        total_size += uploaded_file.file.size
      end
    end
    total_size
  end

  private

  def one_gig_max_storage_per_pod
    size = UploadedFile.total_storage_taken_for_pod(self.pod_membership.pod)
    if size > 1200000000 # approximately 1GB
      self.errors.add(:base, 'The file you\'re trying to add would put you over the 1 GB limit of file storage. Please try again with a smaller file. If you require more than 1 GB of file storage, email us at podinfo@podkeeper.com')
      false
    end
  end

  def assign_default_description
    if self.url.present?
      self.description = self.url
    else
      self.description = self.identifier.split('.')[0].gsub('-', ' ').gsub('_', ' ')
    end
  end

end
