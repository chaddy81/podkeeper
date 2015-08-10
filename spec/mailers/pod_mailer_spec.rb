require 'rails_helper'

describe PodMailer do
  let!(:user) { FactoryGirl.create(:user, time_zone: 'Central Time (US & Canada)', first_name: 'John', last_name: 'Doe') }
  let!(:pod) { FactoryGirl.create(:pod) }

  describe 'Pod Creation Confirmation' do
    let(:mail) { PodMailer.pod_creation_confirmation(pod) }

    it 'renders the subject' do
      expect(mail.subject).to eql("Your #{pod.name} Pod has been created")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([pod.organizer.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['podmember@email.podkeeper.com'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(pod.organizer.first_name)
    end

    it 'assigns @email' do
      expect(mail.body.encoded).to match(pod.organizer.email)
    end

    it 'renders link to dashboard' do
      expect(mail.body.encoded).to include(dashboard_pod_url(pod.slug))
    end

    it 'has settings url in footer' do
      expect(mail.body.encoded).to have_link('Settings', href: settings_url)
    end

    it 'should not have Decline Pod' do
      expect(mail.body.encoded).not_to have_link('Decline this Pod')
    end
  end

  describe 'Joined Pod Confirmation' do
    let(:mail) { PodMailer.join_pod_confirmation(pod, user) }

    it 'renders the subject' do
      expect(mail.subject).to eql("You've joined this Pod - #{pod.name}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([pod.organizer.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['podmember@email.podkeeper.com'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns @email' do
      expect(mail.body.encoded).to match(user.email)
    end

    it 'renders link to dashboard' do
      expect(mail.body.encoded).to include(dashboard_pod_url(pod.slug))
    end

    it 'has settings url in footer' do
      expect(mail.body.encoded).to have_link('Settings', href: settings_url)
    end

    it 'should not have Decline Pod' do
      expect(mail.body.encoded).not_to have_link('Decline this Pod')
    end
  end
end