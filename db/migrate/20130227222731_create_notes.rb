class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :topic
      t.text :body
      t.integer :event_id
      t.integer :user_id
      t.boolean :is_urgent, default: false
      t.date :urgent_until

      t.timestamps
    end
  end
end
