class CreateListItems < ActiveRecord::Migration
  def change
    create_table :list_items do |t|
      t.integer :list_id
      t.text :notes
      t.text :item
      t.integer :user_id

      t.timestamps
    end
  end
end
