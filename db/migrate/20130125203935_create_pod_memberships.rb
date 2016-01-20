class CreatePodMemberships < ActiveRecord::Migration
  def change
    create_table :pod_memberships do |t|
      t.integer :user_id
      t.integer :pod_id

      t.timestamps
    end
  end
end
