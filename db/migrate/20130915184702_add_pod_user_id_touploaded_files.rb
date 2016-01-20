class AddPodUserIdTouploadedFiles < ActiveRecord::Migration
  def change
    remove_column :uploaded_files, :user_id
    add_column :uploaded_files, :pod_user_id, :integer
    add_index :uploaded_files, :pod_user_id
  end
end
