module UploadedFilesHelper
  def show_file_notification(pod, file)
    if current_user.pod_memberships.find_by_pod_id(pod.id).last_visit_files < file.created_at && file.pod_membership.user != current_user
      return true
    else
      return false
    end
  end
end
