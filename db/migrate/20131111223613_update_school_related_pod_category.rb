class UpdateSchoolRelatedPodCategory < ActiveRecord::Migration
  def change
    PodCategory.where(name: 'school_related').update_all(display_name: 'School Class / PTA')
  end
end
