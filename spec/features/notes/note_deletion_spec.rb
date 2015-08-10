require 'rails_helper'

describe 'delete note', js: true do

  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:note) { FactoryGirl.create(:note, user: user, pod: pod) }

  before do
    sign_in user
    visit notes_path(pod_id: pod.id)
    click_link "delete_note_#{note.id}"
  end

  it { should have_content('Are you sure') }
  it { should have_content('comments will also be deleted') }

  describe "OK to deletion" do
    before do
      within '.modal-dialog' do
        click_link 'OK'
      end
    end

    it { should have_selector('div.alert.alert-success', text: 'deleted successfully') }
  end
end
