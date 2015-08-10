require 'rails_helper'

describe 'edit/update comment', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:note) { FactoryGirl.create(:note, pod: pod) }
  let!(:comment) { FactoryGirl.create(:comment, note: note, user: user) }

  before do
    sign_in user
    visit notes_path(pod_id: pod.id)
    within(".reply") { click_link "edit_comment_#{comment.id}" }
  end

  it { should have_selector('h4', text: 'Edit Comment') }
  it { should have_button('Save') }
  it { should have_link('Cancel') }

  describe 'with invalid information' do
    before do
      within('.modal-dialog') do
        fill_in 'comment_body', with: ' '
        click_button 'Save'
      end
    end
    it { should have_selector('.error') }
  end

  describe 'with valid information' do
    let(:new_comment_body)  { 'Changed' }
    before do
      within('.modal-dialog') do
        fill_in 'comment_body', with: new_comment_body
        click_button 'Save'
      end
    end

    it { should have_selector('.comment__body', text: new_comment_body) }
  end

end
