class AddGetReadyBarExpandedToPodUsers < ActiveRecord::Migration
  def change
    remove_column :users, :get_ready_bar_expanded
    add_column :pod_memberships, :get_ready_bar_expanded, :boolean, default: true
  end
end
