class CreatePods < ActiveRecord::Migration
  def change
    create_table :pods do |t|
      t.string :name
      t.string :description
      t.integer :category_id
      t.integer :organizer_id

      t.timestamps
    end
  end
end
