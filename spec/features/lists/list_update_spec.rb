require 'rails_helper'

describe 'list edit/update' do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:list_type) { FactoryGirl.create(:list_type) }
  let!(:list) { FactoryGirl.create(:list, list_type: list_type, creator: user, pod: pod) }

  before do
    sign_in user
    visit edit_list_path(list)
  end

  it { should have_content('List Details') }

  context 'with invalid details' do
    before do
      fill_in 'list_name', with: ''
      click_button 'Submit'
    end

    it { should have_selector('span.help-inline', text: "can't be blank") }
  end

  context 'with valid details' do
    before do
      fill_in 'list_name', with: 'My New Title'
      click_button 'Submit'
    end

    it { should have_content('My New Title') }
    it { should have_selector('div.alert.alert-success', text: 'updated successfully') }
  end
end
