class AddSingleEventToEvent < ActiveRecord::Migration
  def change
    add_column :events, :single_event, :boolean, default: true
  end
end
