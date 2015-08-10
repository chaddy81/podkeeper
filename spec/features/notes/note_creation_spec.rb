require 'rails_helper'

describe 'creating a note', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:note) { FactoryGirl.build(:note) }

  before do
    sign_in user
    visit notes_path(pod_id: pod.id)
  end

  describe 'it shows full form on next click' do
    before do
      fill_in 'topic', with: note.topic
      click_button 'Next'
    end

    it { should have_selector('.step-1.hide-step', visible: false) }
    it { should have_selector('.step-2.show-step') }
    it { should have_field('note_topic', with: note.topic) }
  end

  describe 'with invalid information' do
    before do
      fill_in 'Topic', with: note.topic
      click_button 'Next'
    end

    it 'should not create a note' do
      expect { click_button 'Post' }.not_to change(Note, :count)
    end

    describe 'error messages' do
      before { click_button 'Post' }

      it { should have_selector('.alert-error') }
    end
  end

  describe 'with valid information' do
    before do
      fill_in 'Topic', with: note.topic
      click_button 'Next'
      fill_in 'note_body', with: note.body
    end

    describe 'after saving the note' do
      before { click_button 'Post' }

      it { should have_selector('div.alert.alert-success', text: 'was created') }
      it 'blah' do
        should have_selector('.discussion__title', text: note.topic)
      end
      it { should have_selector('.discussion__author', text: user.full_name) }
      it { should have_selector('.discussion__body', text: note.body) }
    end
  end

end
