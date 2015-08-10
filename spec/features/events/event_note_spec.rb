require 'rails_helper'

describe 'Event Note pages', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:event) { FactoryGirl.create(:event, pod: pod) }
  let!(:y_option) { FactoryGirl.create(:rsvp_option) }
  let!(:n_option) { FactoryGirl.create(:rsvp_option, name: 'no') }
  let!(:u_option) { FactoryGirl.create(:rsvp_option, name: 'maybe') }

  before do
    sign_in user
    visit dashboard_pod_path(pod)
    click_link "Events"
    find('.info__controls').click
    click_link "Send additional reminder"
  end

  describe 'sending a note about an event' do
    let(:event_note) { FactoryGirl.build(:event_note) }

    describe 'with invalid information' do
      describe 'it throws an error' do
        before { click_button 'Send' }

        it { should have_selector('.error') }
      end
    end

    describe 'with valid information' do
      before do
        fill_in 'Reminder Message', with: event_note.note
        check 'All Pod members'
      end

      describe 'after sending the note' do
        before { click_button 'Send' }

        it { should have_selector('div.alert.alert-success', text: 'success') }
      end
    end
  end

end
