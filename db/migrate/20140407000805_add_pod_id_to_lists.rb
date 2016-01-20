class AddPodIdToLists < ActiveRecord::Migration
  def change
    add_column :lists, :pod_id, :integer
  end
end
