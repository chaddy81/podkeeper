require 'rails_helper'

describe 'Comments', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:pod) { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  #let!(:invite) { FactoryGirl.create(:pod_invite, pod: pod) }

  before do
    # window width >= 1000px to display footer navigation
    page.driver.browser.manage.window.resize_to(1000, 600)

    sign_in user
    within('.footer') do
      click_link 'Feedback'
    end
  end

  describe 'new/create' do
    let(:site_comment) { FactoryGirl.build(:site_comment) }

    it { should have_selector('h5', text: 'Let us know') }

    describe 'with invalid information' do
      it 'should not create a note' do
        expect { click_button 'Submit' }.not_to change(SiteComment, :count)
      end

      describe 'error messages' do
        before { click_button 'Submit' }

        it { should have_selector('.help-inline') }
      end
    end

    describe 'with valid information' do
      before { fill_in 'comment', with: site_comment.body }

      describe 'after saving the comment' do
        before { click_button 'Submit' }

        it { should have_selector('div.alert.alert-success', text: 'Thank you') }
      end
    end
  end # end new/create

end
