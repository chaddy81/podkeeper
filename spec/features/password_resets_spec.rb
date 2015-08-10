require 'rails_helper'

describe 'Password Email Reset' do
  subject { page }

  describe 'Recovery mechanism' do

    before do
      visit signin_path
      within('#signin-form') do
        click_link 'Password'
      end
    end

    describe 'sends the user an email' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        within('#password-reset') do
          fill_in 'email', with: user.email
          click_button 'Reset'
        end
      end
      it { should have_selector('.alert-notice', text: 'An email has been sent') }
    end

    describe 'doesnt send email to invalid user' do
      before do
        within('#password-reset') do
          fill_in 'email', with: 'fake.user@gmail.com'
          click_button 'Reset'
        end
      end
      it { should have_selector('div.alert-error', text: 'Could not find that email address') }
    end
  end # end recovery mechanism

end
