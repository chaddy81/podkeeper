class CreateDeletedPodAttributes < ActiveRecord::Migration
  def change
    create_table :deleted_pod_attributes do |t|
      t.integer :creator_id
      t.string :creator_first_name
      t.string :creator_last_name
      t.integer :number_of_pod_admins
      t.integer :number_of_members
      t.integer :number_of_open_invites
      t.integer :number_of_discussions
      t.integer :number_of_comments
      t.integer :number_of_upcoming_events
      t.integer :number_of_past_events
      t.integer :number_of_task_lists
      t.integer :number_of_tasks
      t.integer :number_of_documents
      t.string :pod_name
      t.integer :deleter_id
      t.string :deleter_first_name
      t.string :deleter_last_name
      t.datetime :pod_deleted_at
      t.datetime :pod_created_at

      t.timestamps
    end
  end
end
