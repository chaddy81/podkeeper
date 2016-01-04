class List < ActiveRecord::Base
  paginates_per 10

  attr_accessible :creator_id, :creator, :details, :list_type_id, :list_type, :name, :list_items_attributes,
                  :pod_id, :pod, :notification_has_been_sent

  scope :updated_yesterday, -> { where(created_at: DateTime.yesterday.beginning_of_day..DateTime.yesterday.end_of_day) }
  default_scope -> { order('created_at DESC') }

  belongs_to :creator, class_name: 'User'
  belongs_to :list_type
  belongs_to :pod
  has_many :list_items, -> { order('created_at ASC') }, dependent: :destroy

  validates :name,      presence: true
  validates :list_type, presence: true

end
