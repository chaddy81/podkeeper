class AddPodIdToDeletedPodAttributes < ActiveRecord::Migration
  def change
    add_column :deleted_pod_attributes, :pod_id, :integer
  end
end
