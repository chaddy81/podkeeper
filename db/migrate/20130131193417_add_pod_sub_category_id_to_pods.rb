class AddPodSubCategoryIdToPods < ActiveRecord::Migration
  def change
    add_column :pods, :pod_sub_category_id, :integer
  end
end
