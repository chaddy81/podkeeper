class RemoveStatusIdFromPods < ActiveRecord::Migration
  def up
    remove_column :pods, :status_id
  end

  def down
    add_column :pods, :status_id, :string
  end
end
