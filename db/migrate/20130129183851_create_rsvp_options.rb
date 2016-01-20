class CreateRsvpOptions < ActiveRecord::Migration
  def change
    create_table :rsvp_options do |t|
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end
end
