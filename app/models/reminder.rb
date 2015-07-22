class Reminder < ActiveRecord::Base
  attr_accessible :invite_id, :invite

  belongs_to :invite

  default_scope -> { order(:created_at) }
end
