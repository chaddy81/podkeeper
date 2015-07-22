class InvalidEmail < ActiveRecord::Base
  attr_accessible :email, :pod_id, :pod, :user_id, :user

  belongs_to :user
  belongs_to :pod

  default_scope -> { order('created_at') }
end
