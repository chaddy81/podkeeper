class CreateEmailNotifications < ActiveRecord::Migration
  def change
    create_table :email_notifications do |t|
      t.string :email
      t.string :sg_event_id
      t.string :sg_message_id
      t.datetime :timestamp
      t.string :smtp_id
      t.string :event
      t.string :email_id
      t.string :uid

      t.timestamps null: false
    end
  end
end
