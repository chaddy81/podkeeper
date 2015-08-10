require 'rails_helper'

describe 'file deletion', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:file) { FactoryGirl.create(:uploaded_file, pod_membership: pod_membership) }

  before do
    sign_in user
    visit uploaded_files_path
    find("#delete_uploaded_file_#{file.id}").click()
    within ".modal-dialog" do
      click_link "OK"
    end
  end

  it { should have_selector('div.alert.alert-success', text: 'removed successfully') }
end
