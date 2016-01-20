class AddPodIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :pod_id, :integer
  end
end
