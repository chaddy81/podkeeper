require 'rails_helper'

describe 'Visitor signs up' do
  subject { page }
  let!(:category) { FactoryGirl.create(:pod_category, name: 'other', display_name: 'Other') }

  describe 'with valid information' do
    before { sign_up_with('guy@example.com', 'secret_password', 'Guy', 'Example', 'My Pod', category.display_name) }

    it { should have_content('Welcome to PodKeeper!') }
    it { should have_content('Thank You for becoming a member of PodKeeper') }
  end

  describe 'with invalid information' do
    it 'does not create a user' do
      expect {
        sign_up_with('guy@example.com', '', 'Guy', 'Example', '', category.display_name)
      }.not_to change(User, :count)
    end

    it 'displays an error message' do
      sign_up_with('guy@example.com', '', 'Guy', 'Example', '', category.display_name)
      page.should have_selector('div.alert.alert-error', text: "can't be blank")
    end
  end
end
