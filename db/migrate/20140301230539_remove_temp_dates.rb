class RemoveTempDates < ActiveRecord::Migration
  def change
    remove_column :events, :temp_start_time
    remove_column :events, :temp_end_time
  end
end
