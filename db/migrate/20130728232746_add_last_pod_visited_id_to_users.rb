class AddLastPodVisitedIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_pod_visited_id, :integer
  end
end
