class AddColorToRsvpOptions < ActiveRecord::Migration
  def change
    add_column :rsvp_options, :color, :string
  end
end
