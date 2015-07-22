class ListItem < ActiveRecord::Base
  attr_accessible :item, :list_id, :list, :notes, :user_id, :user, :row_number, :sign_me_up
  attr_accessor :row_number, :sign_me_up

  belongs_to :user
  belongs_to :list

  validates :item, presence: true
  # validates :user_id, presence: true

end
