require 'rails_helper'

describe 'Authentication' do
  subject { page }
  before { visit signin_path }

  describe 'with invalid credentials' do
    before {
      within('#signin-form') do
        click_button 'Sign In'
      end
    }

    it { should have_selector('div.alert-error', text: 'Invalid') }
  end

  describe 'with valid credentials' do
    describe 'as active user', js: true do
      let!(:user) { FactoryGirl.create(:user) }
      before do
        within('#signin-form') do
          fill_in 'email',    with: user.email
          fill_in 'password', with: user.password
          click_button 'Sign In'
        end
      end

      it { should have_link('Create a Pod', href: new_pod_path) }

      describe 'has signout link' do
        it { should have_link('Sign Out', visible: false) }
        it { should_not have_link 'Sign In' }
      end

      describe 'followed by signout', js: true do
        before { sign_out_js(user) }

        it { should have_button('Sign In') }
      end
    end # as active user

    describe 'as inactive user' do
      let!(:user) { FactoryGirl.create(:user, active: false) }
      before do
        within('#signin-form') do
          fill_in 'email',    with: user.email
          fill_in 'password', with: user.password
          click_button 'Sign In'
        end
      end

      it { should_not have_link('Create a Pod', href: new_pod_path) }
      it { should have_selector('div.alert-error', text: 'Invalid') }

      describe 'does not have signout link' do
        it { should_not have_link 'Sign Out' }
        it { should have_button 'Sign In' }
      end
    end # as inactive user

  end # end with valid information
end
