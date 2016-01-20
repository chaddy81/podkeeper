class AddStatusIdToPods < ActiveRecord::Migration
  def change
    add_column :pods, :status_id, :integer
  end
end
