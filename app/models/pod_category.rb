class PodCategory < ActiveRecord::Base
  attr_accessible :display_name, :name

  has_many :pods
  has_many :pod_sub_categories

  default_scope -> { order('display_name') }

  def self.in_order
    pod_categories = PodCategory.all.reject { |p| p.name == 'other' }
    pod_categories << PodCategory.find_by_name('other')
  end

  def subcategories_in_order
    categories = self.pod_sub_categories.reject { |p| p.name == 'other' }
    categories << PodSubCategory.find_by_name('other')
  end

end
