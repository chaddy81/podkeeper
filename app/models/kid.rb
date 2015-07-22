class Kid < ActiveRecord::Base
  attr_accessible :name, :pod_id, :pod, :user_id, :user

  belongs_to :user
  belongs_to :pod

  validates :name, presence: true

end
