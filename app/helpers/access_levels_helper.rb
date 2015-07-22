module AccessLevelsHelper

  def is_at_least_pod_admin?
    current_pod_membership && current_pod_membership.pod_admin?
  end

  def is_pod_admin_with_sharing?
    current_pod_membership && current_pod_membership.pod_admin_with_sharing?
  end

  def current_pod_membership
    if signed_in? && current_pod
      current_user.pod_memberships.where(pod_id: current_pod.id).last
    end
  end

  def pod_admin_with_sharing
    @pod_admin_with_sharing || AccessLevel.pod_admin_with_sharing
  end

  def pod_admin
    @pod_admin || AccessLevel.pod_admin
  end

end