class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :pod_id
      t.string :email
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
