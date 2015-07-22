class ListType < ActiveRecord::Base
  attr_accessible :display_name, :name

  has_many :lists
end
