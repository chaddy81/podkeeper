class AddDummyDateToSectionLastVisit < ActiveRecord::Migration
  def change
    dummy_date = DateTime.new(2000,1,1)
    PodMembership.where('last_visit_notes is null').update_all(last_visit_notes: dummy_date)
    PodMembership.where('last_visit_events is null').update_all(last_visit_events: dummy_date)
    PodMembership.where('last_visit_lists is null').update_all(last_visit_lists: dummy_date)
    PodMembership.where('last_visit_files is null').update_all(last_visit_files: dummy_date)
  end
end
