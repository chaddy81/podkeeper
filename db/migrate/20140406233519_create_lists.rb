class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :list_type_id
      t.string :name
      t.text :details
      t.integer :creator_id

      t.timestamps
    end
  end
end
