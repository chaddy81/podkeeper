class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.string :name
      t.integer :user_id
      t.integer :pod_id

      t.timestamps
    end
  end
end
