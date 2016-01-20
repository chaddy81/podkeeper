class RemoveOldFieldsFromSettings < ActiveRecord::Migration
  def up
    remove_column :settings, :event_two_week_notice
    remove_column :settings, :event_one_week_notice
    remove_column :settings, :event_three_day_notice
    remove_column :settings, :task_list_create_notice
  end

  def down
    add_column :settings, :task_list_created, :string
    add_column :settings, :event_three_day_notice, :string
    add_column :settings, :event_one_week_notice, :string
    add_column :settings, :event_two_week_notice, :string
  end
end
