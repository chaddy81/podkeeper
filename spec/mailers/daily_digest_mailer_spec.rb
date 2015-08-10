require 'rails_helper'

describe DailyDigestMailer do
  describe 'daily_digest' do

    # Users for tests
    let!(:user) { FactoryGirl.create(:user, time_zone: 'Central Time (US & Canada)') }
    let!(:user2) { FactoryGirl.create(:user, time_zone: 'Central Time (US & Canada)', first_name: 'John', last_name: 'Doe', email: 'johndoe@test.com') }
    let!(:user3) { FactoryGirl.create(:user, time_zone: 'Central Time (US & Canada)', first_name: 'Jane', last_name: 'Doe', email: 'janedoe@test.com') }

    # Pods for tests
    let!(:pod) { FactoryGirl.create(:pod, created_at: Date.yesterday)}

    # Pod Memberships for tests
    let!(:pm) { FactoryGirl.create(:pod_membership, user: user, pod: pod, created_at: Date.yesterday, access_level: admin_w_grant_access)}
    let!(:pm2) { FactoryGirl.create(:pod_membership, user: user2, pod: pod, created_at: Date.yesterday, access_level: member_access)}

    # Access levels for tests
    let!(:admin_access)  { FactoryGirl.create(:access_level) }
    let!(:member_access) { FactoryGirl.create(:access_level, name: 'member') }
    let!(:admin_w_grant_access) { FactoryGirl.create(:access_level, name: 'pod_admin_with_grant_option') }

    # Deleted Pod Memberships
    let!(:deleted_pod) { FactoryGirl.create(:pod_membership, user: user3, pod: pod, created_at: Date.today - 1.week, deleted_at: DateTime.now - 1.day, access_level_id: 1)}

    # Declined Pod Invite
    let!(:declined_invite) { FactoryGirl.create(:pod_invite, pod: pod, declined: true, inviter: user, updated_at: DateTime.now - 1.day) }

    # Events for pods
    let!(:event)  { FactoryGirl.create(:event, pod: pod, organizer: user, name: "New Event") }
    let!(:event2) { FactoryGirl.create(:event, pod: pod, organizer: user, name: "New Event 2", require_rsvp: true, completed: false) }
    let!(:event3) { FactoryGirl.create(:event, pod: pod, organizer: user, name: "Event Today", start_date: Date.today, street: '123 st', city: 'Portage', state: 'MI', zipcode: 49024) }

    let!(:rsvp_option) { FactoryGirl.create(:rsvp_option, name: 'no') }
    let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, event: event2, rsvp_option: rsvp_option) }

    # Notes
    let!(:note) { FactoryGirl.create(:note, user: user, pod: pod) }

    # Files
    let!(:file) { FactoryGirl.create(:uploaded_file, pod_membership: pm, url: 'http://placehold.it/350x350', created_at: DateTime.now - 1.day) }

    # Email object for tests
    let!(:mail) { DailyDigestMailer.daily_digest(user) }

    specify { mail.subject.should == "Daily Digest of #{Time.now.strftime('%A, %B %d')}" }
    specify { mail.to.should == [user.email] }
    specify { mail.from.should == ['podmember@email.podkeeper.com'] }
    specify { mail.body.should have_link('Go to PodKeeper', href: root_url) }

    describe 'Pods where user is admin' do
      specify { mail.body.encoded.should have_css('h2', text: 'Soccer Team') }

      context "where accepted invites are displayed" do
        specify { mail.body.encoded.should have_css('.accepted-invites div', text: "1") }
        specify { mail.body.encoded.should have_css('.accepted-invites div', text: "John Doe") }
      end

      context "where declined invites are displayed" do
        specify { mail.body.encoded.should have_css('.declined-invites div', text: "1") }
        specify { mail.body.encoded.should have_css('.declined-invites div', text: "John Smith") }
      end

      context "where deleted pod memberships are displayed" do
        specify { mail.body.encoded.should have_css('.deleted-membership div', text: "1") }
        specify { mail.body.encoded.should have_css('.deleted-membership div', text: "Jane Doe") }
      end

    end

    describe 'Events from users pods' do
      context 'where event was added today' do
        specify { mail.body.encoded.should have_css('p', text: 'Added')}
        specify { mail.body.encoded.should have_css('.new-events div', text: "New Event")}
        specify { mail.body.encoded.should have_css('.new-events div', text: event.start_date_time.in_time_zone(user.time_zone).strftime('%a %b %d, %l:%M %p'))}
      end

      context 'where event still requires RSVP' do
        specify { mail.body.encoded.should have_css('p', text: 'Still requires your RSVP')}
        specify { mail.body.encoded.should have_link('New Event 2')}
        specify { mail.body.encoded.should have_css('.require-rsvp div', text: event2.start_date_time.in_time_zone(user.time_zone).strftime('%a %b %d, %l:%M %p'))}
      end

      context 'where event takes place today' do
        specify { mail.body.encoded.should have_css('p', text: 'Today’s Event(s)')}
        specify { mail.body.encoded.should have_css('.events-today div', text: "Event Today")}
        specify { mail.body.encoded.should have_css('.events-today div', text: event3.start_date_time.in_time_zone(user.time_zone).strftime('%a %b %d, %l:%M %p'))}
        specify { mail.body.encoded.should have_css('.events-today div', text: 'City Park, 123 st, Portage, MI 49024')}
      end

    end

    describe 'Discussions from users pods' do
      specify { mail.body.encoded.should have_css('p', text: 'Discussions') }
      specify { mail.body.encoded.should have_css('.discussions span', text: 'Troop Meeting') }
      specify { mail.body.encoded.should have_css('.discussions span', text: 'Make sure to remember your books.') }
      specify { mail.body.encoded.should have_link('View Comments') }
    end

    describe 'Lists from users pods' do
    end

    describe 'Files from users pods' do
      specify { mail.body.encoded.should have_css('p', text: 'Files') }
      specify { mail.body.encoded.should have_css('.files div', text: 'http://placehold.it/350x350') }
    end

    describe 'Link to create/list pods' do
      specify { mail.body.encoded.should have_link('Go to PodKeeper') }
    end

  end
end
