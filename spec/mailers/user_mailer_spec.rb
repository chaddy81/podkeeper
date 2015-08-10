require 'rails_helper'

describe UserMailer do

  let!(:user) { FactoryGirl.create(:user, time_zone: 'Central Time (US & Canada)', first_name: 'John', last_name: 'Doe', password_reset_token: SecureRandom.hex(12)) }

  describe 'Welcome to Podkeeper' do
    let(:mail) { UserMailer.new_user_welcome(user) }

    it 'renders the subject' do
      expect(mail.subject).to eql('Welcome to PodKeeper')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
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

    it 'has settings url in footer' do
      expect(mail.body.encoded).to have_link('Settings', href: settings_url)
    end

    it 'should not have Decline Pod' do
      expect(mail.body.encoded).not_to have_link('Decline this Pod')
    end
  end

  describe 'Password Reset' do
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the subject' do
      expect(mail.subject).to eql('PodKeeper Password Reset')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eql(['podmember@email.podkeeper.com'])
    end

    it 'assigns @email' do
      expect(mail.body.encoded).to match(user.email)
    end

    it 'renders reset url with token' do
      expect(mail.body.encoded).to have_link(reset_password_from_email_url(user.password_reset_tokens))
    end
  end
end