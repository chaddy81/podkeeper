class AddDeletedAtToPods < ActiveRecord::Migration
  def change
    add_column :pods, :deleted_at, :datetime
  end
end
