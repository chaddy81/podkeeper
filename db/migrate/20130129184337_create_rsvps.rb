class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :rsvp_option_id
      t.text :comments
      t.integer :number_of_adults
      t.integer :number_of_kids

      t.timestamps
    end
  end
end
