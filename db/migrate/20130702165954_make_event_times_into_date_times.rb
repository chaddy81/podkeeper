class MakeEventTimesIntoDateTimes < ActiveRecord::Migration
  def change
    add_column :events, :temp_start_time, :datetime
    add_column :events, :temp_end_time, :datetime

    Event.all.each do |event|
      event.temp_start_time = event.start_time
      event.temp_end_time = event.end_time
      event.save(validate: false)
    end

    remove_column :events, :end_time
    remove_column :events, :start_time

    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime

    Event.all.each do |event|
      event.start_time = event.temp_start_time
      event.end_time = event.temp_end_time
      event.save(validate: false)
    end

  end
end
