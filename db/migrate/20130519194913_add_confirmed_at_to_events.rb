class AddConfirmedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :confirmed_at, :datetime

    Event.all.each do |event|
      event.update_attribute(:confirmed_at, event.created_at)
    end
  end
end
