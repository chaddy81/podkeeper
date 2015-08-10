require 'rails_helper'

describe 'Events pages' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:y_option) { FactoryGirl.create(:rsvp_option) }
  let!(:n_option) { FactoryGirl.create(:rsvp_option, name: 'no') }
  let!(:u_option) { FactoryGirl.create(:rsvp_option, name: 'maybe') }

  before { sign_in user }

  describe 'new/create multiple event' do
    let(:event) { FactoryGirl.build(:event) }
    before { visit new_event_path }

    it { should have_selector('h4', 'Event Details') }
    it { should have_css('input#event_single_event_true') }
    it { should have_css('input#event_single_event_false') }
    it { should have_content('Add End Time') }
    it { should have_content('Total number of weeks in Weekly Series') }
    it { should have_css('input#event_weeks') }
    it { should have_content('You can edit the details of each Event individually after the Weekly Series is created.')}

    describe 'with invalid information' do
      before { click_button 'Review' }

      it { should have_selector('div.alert.alert-error') }
    end

    describe 'with valid information' do
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
  end # end user sign up page

  describe 'confirm' do
    let!(:event) { FactoryGirl.create(:event, pod: pod, confirmed: false) }
    before { visit event_review_path(event) }

    it { should have_link('Edit') }

    describe 'confirming the event' do
      before { click_link 'Finish & Email Invites' }

      it { should have_title(pod.name) }
      it { should have_selector('.alert-success', text: 'success') }
    end
  end

  describe 'edit/update' do
    let(:event) { FactoryGirl.create(:event, pod: pod, organizer: user) }
    before { visit edit_event_path(event) }

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
  end # end edit personal information page

  describe 'index' do
    let!(:event) { FactoryGirl.create(:event, pod: pod, organizer: user) }

    before { visit events_path }

    it { should have_selector('h2', text: 'Events') }
    it { should have_content(event.name) }
  end # end profile page

end
