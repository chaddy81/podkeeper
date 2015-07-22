module ListsHelper
  def show_list_notification(pod, list)
    if current_user.pod_memberships.find_by_pod_id(pod.id).last_visit_lists < list.created_at && list.creator != current_user
      return true
    else
      return false
    end
  end
end