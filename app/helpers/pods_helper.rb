module PodsHelper
  def show_thank_you_modal
   current_user.pod_memberships.with_deleted.count == 0 &&
   current_user.updated_at < current_user.created_at + 10.seconds
  end
end
