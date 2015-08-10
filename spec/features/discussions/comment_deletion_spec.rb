require 'rails_helper'

describe 'comment deletion', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:note) { FactoryGirl.create(:note, pod: pod) }
  let!(:comment) { FactoryGirl.create(:comment, note: note, user: user) }

  before do
    sign_in user
    visit notes_path(pod_id: pod.id)
    within(".reply") { click_link "delete_comment_#{comment.id}" }
    within('.modal-dialog') { click_link 'OK' }
  end

  it { should_not have_content(comment.body) }
end
