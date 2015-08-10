require 'rails_helper'

describe 'list deletion', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:list_type) { FactoryGirl.create(:list_type) }
  let!(:list) { FactoryGirl.create(:list, list_type: list_type, creator: user, pod: pod) }

  before do
    sign_in user
    visit list_path(list)
    click_link "delete_list_#{list.id}"
    within ".modal-dialog" do
      click_link "OK"
    end
  end

  it { should have_selector("div.alert.alert-success", text: 'has been deleted') }
end
