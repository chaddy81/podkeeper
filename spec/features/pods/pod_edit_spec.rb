require 'rails_helper'

describe 'editing pods' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:category) { FactoryGirl.create(:pod_category, name: 'other', display_name: 'Other') }
  let!(:category2) { FactoryGirl.create(:pod_category, name: 'volunteer', display_name: 'Volunteer') }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user, pod_category: category) }
  let!(:access) { FactoryGirl.create(:access_level, name: 'pod_admin') }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod, access_level: access) }

  before do
    sign_in user
    click_link "Pod Admin"
  end

  describe 'changing name' do
    before do
      fill_in 'pod_name', with: 'Updated Pod Name'
      click_button 'Submit'
    end

    it { should have_selector('h3', text: 'Updated Pod Name') }
  end

  describe 'changing description' do
    before do
      fill_in 'pod_description', with: 'This sea animal pod is for example porpoises only.'
      click_button 'Submit'
      click_link 'Pod Details'
    end

    it { should have_content('This sea animal pod is for example porpoises only.') }
  end

  describe 'changing category' do
    before do
      select category2.display_name, from: 'pod_pod_category_id'
      click_button 'Submit'
    end

    it { should have_selector('div.icons__volunteer') }
  end
end
