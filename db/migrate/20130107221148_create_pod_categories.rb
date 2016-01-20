class CreatePodCategories < ActiveRecord::Migration
  def change
    create_table :pod_categories do |t|
      t.string :name
      t.string :display_name

      t.timestamps
    end
  end
end
