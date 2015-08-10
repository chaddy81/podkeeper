require 'rails_helper'

describe 'Event creation' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:y_option) { FactoryGirl.create(:rsvp_option) }
  let!(:n_option) { FactoryGirl.create(:rsvp_option, name: 'no') }
  let!(:u_option) { FactoryGirl.create(:rsvp_option, name: 'maybe') }

  let(:event) { FactoryGirl.build(:event) }

  before {
    sign_in user
    visit new_event_path
  }

  context 'with invalid information' do
      before { click_button 'Review' }
      it { should have_selector('div.alert.alert-error') }
  end

  context 'with valid information' do
    before do
      fill_in 'Event Name',       with: event.name
      fill_in 'Description',      with: event.description
      fill_in 'Location Name',    with: event.location
      fill_in 'event_start_date', with: event.start_date
    end

    describe 'the user is taken to the confirmation page' do
      before { click_button 'Review' }
      it { should have_content(event.description) }
      it { should have_selector('h4', text: 'Event Details') }
    end
  end

  describe 'confirm' do
    let!(:event_1) { FactoryGirl.create(:event, pod: pod, confirmed: false) }
    before { visit event_review_path(event_1) }

    it { should have_link('Edit') }

    describe 'confirming the event' do
      before { click_link 'Finish & Email Invites' }

      it { should have_title(pod.name) }
      it { should have_selector('.alert-success', text: 'success') }
    end
  end

end
