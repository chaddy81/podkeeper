class RemoveUrgentThroughFromNotes < ActiveRecord::Migration
  def change
    remove_column :notes, :urgent_until
  end
end
