class AddLastVisitDates < ActiveRecord::Migration
  def change
    add_column :pod_memberships, :last_visit_notes, :datetime
    add_column :pod_memberships, :last_visit_events, :datetime
    add_column :pod_memberships, :last_visit_lists, :datetime
    add_column :pod_memberships, :last_visit_files, :datetime

  end
end
