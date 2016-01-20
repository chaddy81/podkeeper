class AddConfirmedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :confirmed, :boolean, default: false

    Event.where(confirmed: false).each do |event|
    	event.confirmed = true
    	event.save(validate: false)
    end
  end
end
