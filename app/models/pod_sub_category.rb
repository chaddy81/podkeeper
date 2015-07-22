class PodSubCategory < ActiveRecord::Base
  attr_accessible :display_name, :name, :pod_category_id

  belongs_to :pod_category
  has_many   :pods

  default_scope -> { order('display_name') }
end
