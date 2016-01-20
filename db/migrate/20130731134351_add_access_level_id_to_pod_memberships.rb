class AddAccessLevelIdToPodMemberships < ActiveRecord::Migration
  def change
    add_column :pod_memberships, :access_level_id, :integer
    add_column :pod_memberships, :deleted_at, :datetime

    PodMembership.all.each do |pod_membership|
      if pod_membership.pod.organizer == pod_membership.user
        pod_membership.update_column(:access_level_id, 3)
      else
        pod_membership.update_column(:access_level_id, 1)
      end
    end


  end
end
