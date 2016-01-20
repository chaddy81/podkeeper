class AddPodNameToInvites < ActiveRecord::Migration
  def change
    add_column :invites, :pod_name, :string
  end
end
