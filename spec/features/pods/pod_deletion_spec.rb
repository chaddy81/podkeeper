require 'rails_helper'

describe 'Pod Removal', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:category) { FactoryGirl.create(:pod_category, name: 'other', display_name: 'Other') }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user, pod_category: category) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }

  before { sign_in user }

  describe 'from edit page' do
    before do
      click_link "Pod Admin"
      click_link "How to delete this pod"
      click_link 'Delete this Pod'
    end

    describe 'cancel' do
      before do
        within('div.modal-content') do
          click_link 'Cancel'
        end
      end

      it { should have_selector('h3', text: pod.name.upcase) }
    end

    describe 'confirm' do
      before do
        within('div.modal-content') do
          click_link 'OK'
        end
      end

      it { should have_content('You currently don’t have any Pods.') }
    end
  end
end
