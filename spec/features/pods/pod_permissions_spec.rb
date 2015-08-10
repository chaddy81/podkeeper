require 'rails_helper'

describe 'pod permissions' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:category) { FactoryGirl.create(:pod_category, name: 'other', display_name: 'Other') }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user, pod_category: category) }
  let!(:member_access) { FactoryGirl.create(:access_level, name: 'member', display_name: 'Member') }
  let!(:admin_share_access) { FactoryGirl.create(:access_level, name: 'pod_admin_with_grant_option', display_name: 'Pod Admin with Sharing') }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:pod_membership2) { FactoryGirl.create(:pod_membership, user: user2, pod: pod, access_level: member_access) }

  before do
    sign_in user
    click_link "Pod Admin"
    click_link "Manage Permissions"
  end

  it { should have_content('To change Access Level, click the edit icon') }

  describe 'granting admin to member' do
    before do
      click_link "edit_user_#{user2.id}_permissions"
      select 'Pod Admin', from: 'pod_membership_access_level_id'
      click_button 'Save'
    end

    it { should have_selector('div.alert.alert-success', text: 'updated successfully') }
  end
end
