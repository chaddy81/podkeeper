class AddPodMembershipIdToUploadedFiles < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :pod_membership_id, :integer
    remove_column :uploaded_files, :pod_user_id
  end
end
