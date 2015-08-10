require 'rails_helper'

describe 'edit/update note', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:note) { FactoryGirl.create(:note, user: user, pod: pod) }

  before do
    sign_in user
    visit notes_path(pod_id: pod.id)
  end

  describe 'edit/update' do
    before do
      visit notes_path(pod_id: pod.id)
      within('.discussion__controls') { click_link "edit_note_#{note.id}" }
    end

    it { should have_selector('h4', text: 'Edit Discussion') }
    it { should have_link('Cancel') }

    describe 'with invalid information' do
      before do
        within('.modal') do
          fill_in 'note_body', with: ' '
          click_button 'Update'
        end
      end
      it { should have_selector('.error') }
    end

    describe 'with valid information' do
      let(:new_note_body)  { 'Changed' }
      before do
        within('.modal') do
          fill_in 'note_body', with: new_note_body
          click_button 'Update'
        end
      end

      it { should have_selector('div.alert.alert-success', text: 'was updated') }
      it { should have_selector('.discussion__body', text: new_note_body) }
    end
  end
end
