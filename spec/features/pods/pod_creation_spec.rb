require 'rails_helper'

describe 'Pod Creation' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:access) { FactoryGirl.create(:access_level, name: 'pod_admin') }
  let!(:member_access) { FactoryGirl.create(:access_level, name: 'member', display_name: 'Member') }
  let!(:admin_share_access) { FactoryGirl.create(:access_level, name: 'pod_admin_with_grant_option', display_name: 'Pod Admin with Sharing') }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod, access_level: access) }
  let!(:category) { FactoryGirl.create(:pod_category, name: 'other', display_name: 'Other') }
  let!(:sports_category) { FactoryGirl.create(:pod_category, name: 'sports', display_name: 'Sports') }
  let!(:sub_cateogry1) { FactoryGirl.create(:pod_sub_category, name: 'hockey', display_name: 'Hockey', pod_category: sports_category) }
  let!(:sub_cateogry2) { FactoryGirl.create(:pod_sub_category, name: 'other', display_name: 'Other', pod_category: sports_category) }
  let(:pod1) { FactoryGirl.build(:pod) }

  before { sign_in user }

  describe 'new/create' do
    before { visit new_pod_path }
    it { should have_selector('h3', text: 'Create Pod') }

    describe 'with invalid information' do
      before do
        within('#new_pod') do
          click_button 'Submit'
        end
      end

      it { should have_selector('div.alert.alert-error', text: "can't be blank") }
    end

    describe 'with valid information' do
      before do
        within('#new_pod') do
          fill_in 'pod_name', with: pod1.name
          fill_in 'pod_description', with: pod1.description
          select category.display_name, from: 'pod_pod_category_id'

          click_button 'Submit'
        end
      end

      it { should have_selector('div.alert.alert-success', text: 'Congratulations! You have added a new Pod') }
    end

    describe 'selecting a sub category', js: true do
      before do
        within('#new_pod') do
          fill_in 'pod_name', with: pod1.name
          fill_in 'pod_description', with: pod1.description
          select sports_category.display_name, from: 'pod_pod_category_id'
        end
      end

      it { should have_selector('#pod_pod_sub_category_id', visible: true) }

      context 'clicking submit' do
        before do
          select sub_cateogry1.display_name, from: 'pod_pod_sub_category_id'
          click_button 'Submit'
        end

        it { should have_selector('div.alert.alert-success', text: 'Congratulations! You have added a new Pod') }
      end
    end

  end
end
