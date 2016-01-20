class AddTimeZoneToEvents < ActiveRecord::Migration
  def change
    add_column :events, :time_zone, :string

    Event.all.each do |event|
      event.update_attribute(:time_zone, 'America/New_York')
    end

  end
end
