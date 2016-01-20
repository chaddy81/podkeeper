class AddHasSeenGetPodGoingToUser < ActiveRecord::Migration
  def change
    add_column :users, :has_seen_get_pod_going, :boolean, default: false
  end
end
