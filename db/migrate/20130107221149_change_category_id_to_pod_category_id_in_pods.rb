class ChangeCategoryIdToPodCategoryIdInPods < ActiveRecord::Migration
  def change
  	rename_column :pods, :category_id, :pod_category_id
  end
end
