require 'rails_helper'

describe 'Edit/Update events' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:y_option) { FactoryGirl.create(:rsvp_option) }
  let!(:n_option) { FactoryGirl.create(:rsvp_option, name: 'no', display_name: 'No') }
  let!(:u_option) { FactoryGirl.create(:rsvp_option, name: 'maybe', display_name: 'Maybe') }
  let(:event) { FactoryGirl.create(:event, pod: pod, organizer: user) }

  before {
    sign_in user
    visit edit_event_path(event)
  }

  it { should have_selector('h3', 'Edit Event') }

  describe 'with invalid information' do
    before do
      fill_in 'Event Name', with: ' '
      click_button 'Save'
    end
    it { should have_selector('div.error') }
  end

  describe 'with valid information' do
    let(:new_name)  { 'Changed' }
    before do
      fill_in 'Event Name',   with: new_name
      click_button 'Save'
    end

    it { should have_title(pod.name) }
    it { should have_selector('div.alert.alert-success', text: 'success') }

    specify { event.reload.name.should  == new_name }
  end

  context 'change RSVP' do
    before do
      visit events_path
      click_link 'Change RSVP'
    end

    describe 'with invalid information', js: true do
      before do
        within '#new_rsvp' do
          click_button 'Save'
        end
      end

      it { should have_selector('div.alert.alert-warning', text: 'at least one person') }
    end

    describe 'with valid information', js: true do
      before do
        within '#new_rsvp' do
          fill_in 'Adults', with: 1
          choose 'Yes'
          click_button 'Save'
        end
      end

      it { should have_selector('div.alert.alert-success', text: 'success') }
    end

  end
end
