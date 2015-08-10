require 'rails_helper'

describe 'List creation', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:list_type) { FactoryGirl.create(:list_type) }

  before { sign_in user }

  describe 'new/create' do
    let(:list) { FactoryGirl.build(:list) }

    before { visit new_list_path(pod_id: pod.id) }

    it { should have_selector('h4', text: 'List Details') }

    describe 'with invalid information' do
      it 'should not create a list' do
        expect { click_button 'Submit' }.not_to change(List, :count)
      end

      describe 'error messages' do
        before { click_button 'Submit' }

        it { should have_title('New List') }
        it { should have_selector('.help-inline') }
      end
    end

    describe 'with valid information' do
      before do
        select list_type.display_name, from: 'List type'
        fill_in 'List Name', with: list.name
        click_button 'Submit'
      end

      it { should have_title('Lists') }
      it { should have_selector('div.alert.alert-success', text: 'created successfully') }
    end
  end

end
