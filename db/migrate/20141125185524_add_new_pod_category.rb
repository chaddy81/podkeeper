class AddNewPodCategory < ActiveRecord::Migration
  def up
    PodCategory.create(name: 'family', display_name: 'Family')
  end

  def down
    PodCategory.find_by_name('family').destroy
  end
end
