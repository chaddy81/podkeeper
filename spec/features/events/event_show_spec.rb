require 'rails_helper'

describe 'showing events' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:y_option) { FactoryGirl.create(:rsvp_option) }
  let!(:n_option) { FactoryGirl.create(:rsvp_option, name: 'no') }
  let!(:u_option) { FactoryGirl.create(:rsvp_option, name: 'maybe') }
  let!(:event) { FactoryGirl.create(:event, pod: pod, organizer: user) }
  let!(:past_event) { FactoryGirl.create(:event, pod: pod, organizer: user, completed: true) }

  before {
    sign_in user
    visit events_path
  }

  it { should have_selector('h2', text: 'Events') }
  it { should have_content(event.name) }
  it { should_not have_content(past_event.name) }

  context "past events" do
    before { click_link "Past" }

    it { should have_content(past_event.name) }
    it { should_not have_content(event.name) }
  end
end


