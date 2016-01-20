class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.text :additional_info
      t.string :location
      t.string :phone
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.boolean :require_rsvp, default: true
      t.integer :pod_id
      t.integer :organizer_id

      t.timestamps
    end
  end
end
