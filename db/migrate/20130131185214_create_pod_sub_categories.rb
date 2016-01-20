class CreatePodSubCategories < ActiveRecord::Migration
  def change
    create_table :pod_sub_categories do |t|
      t.integer :pod_category_id
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end
end
