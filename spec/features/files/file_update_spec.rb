require 'rails_helper'

describe 'edit/update files' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:file) { FactoryGirl.create(:uploaded_file, pod_membership: pod_membership) }

  before do
    sign_in user
    visit edit_uploaded_file_path(file)
    fill_in 'uploaded_file_description', with: 'A New Description'
    within "#edit_uploaded_file_#{file.id}" do
      click_button 'Save'
    end
  end

  it { should have_selector('div.alert.alert-success', text: 'updated successfully') }

end
