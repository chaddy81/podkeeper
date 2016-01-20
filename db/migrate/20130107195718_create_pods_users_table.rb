class CreatePodsUsersTable < ActiveRecord::Migration
  def change
  	create_table :pods_users, id: false do |t|
	  t.references :pod, :user
	end

	add_index :pods_users, [:pod_id, :user_id]
  end
end
