class AddGetReadyBarExpandedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :get_ready_bar_expanded, :boolean, default: true
  end
end
