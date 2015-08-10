require 'rails_helper'

describe 'file creation', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }

  before do
    sign_in user
    visit uploaded_files_path
    find("a[data-new-file='true']").click()
  end

  describe 'uploading file' do
    before { attach_file 'uploaded_file_file', "#{Rails.root}/spec/support/running_tests.gif" }
    it { should have_selector('div.alert.alert-success', text: 'added sucessfully') }
  end

  describe 'giving a link'
end
