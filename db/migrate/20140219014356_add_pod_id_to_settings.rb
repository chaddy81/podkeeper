class AddPodIdToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :pod_id, :integer
  end
end
