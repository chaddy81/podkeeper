require 'rails_helper'

describe 'comment creation', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:note) { FactoryGirl.create(:note, pod: pod) }
  let(:comment) { FactoryGirl.build(:comment) }

  before do
    sign_in user
    visit dashboard_pod_path(pod)
    click_link 'Discussions'
  end

  describe 'with invalid information' do
    before do
      within '#new_comment' do
        click_button 'Post'
      end
    end

    it { should have_selector('.alert.alert-error', text: "can't be blank") }
  end

  describe 'with valid information' do
    before { fill_in 'comment_body', with: comment.body }

    describe 'after saving the comment' do
      before do
        within('#new_comment') do
          click_button 'Post'
        end
      end

      it { should have_selector('h3', pod.name) }
      it { should have_selector('div.alert.alert-success', text: 'was created') }
      it { should have_selector('.comment__author', text: user.first_name) }
      it { should have_selector('.comment__body', text: comment.body) }
    end
  end

end
