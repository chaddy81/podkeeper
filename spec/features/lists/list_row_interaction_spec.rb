require 'rails_helper'

describe 'List row interaction', js: true do
  subject { page }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user, first_name: 'John', last_name: 'Public') }
  let!(:pod)  { FactoryGirl.create(:pod, organizer: user) }
  let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user, pod: pod) }
  let!(:pod_membership2) { FactoryGirl.create(:pod_membership, user: user2, pod: pod) }
  let!(:list_type) { FactoryGirl.create(:list_type) }
  let!(:list) { FactoryGirl.create(:list, list_type: list_type, creator: user, pod: pod) }
  let!(:item) { FactoryGirl.create(:list_item, list: list) }

  before { sign_in user }

  describe 'add row' do
    before { visit list_path(list) }

    describe 'with invalid information' do
      before { click_button 'Save' }

      it { should have_selector('span.help-inline', text: "can't be blank") }
    end

    describe 'with valid information' do
      before do
        fill_in 'list_item_item', with: 'Potato Salad'
        click_button 'Save'
      end

      it { should have_selector('td', text: 'Potato Salad') }
    end
  end

  describe 'remove row' do
    before do
      visit list_path(list)
      within("tr[data-list-item-id='#{item.id}'] .list__controls") do
        page.find('.icons__delete').click
      end
    end

    describe 'rejecting confirmation' do
      before do
        within('div.modal-content') do
          click_link 'Cancel'
        end
      end

      it { should have_selector('td', text: 'cookies') }
    end

    describe 'accepting confirmation' do
      before do
        within('div.modal-content') do
          click_link 'OK'
        end
      end

      it { should_not have_selector('td', text: 'cookies') }
    end
  end

  describe 'update row' do
    before do
      visit list_path(list)
      within("tr[data-list-item-id='#{item.id}'] .list__controls") do
        page.find('.icons__edit').click
      end
    end

    describe 'assigning list item' do
      describe 'assign self' do
        before do
          within("form#edit_list_item_#{item.id}") do
            choose('Sign Me Up')
            click_button 'Save'
          end
        end

        it { should have_selector('td', text: user.full_name) }
      end

      describe 'assign pod member' do
        before do
          within("form#edit_list_item_#{item.id}") do
            select(user2.full_name, from: 'pod-users')
            click_button 'Save'
          end
        end

        it { should have_selector('td', text: user2.full_name) }
      end

    end

    describe 'adding notes' do
      before do
        within("form#edit_list_item_#{item.id}") do
          fill_in 'Notes', with: 'Chocolate Chip, please.'
          click_button 'Save'
        end
      end

      it { should have_selector('td', text: 'Chocolate Chip, please.') }
    end

    describe 'changing item name' do
      before do
        within("form#edit_list_item_#{item.id}") do
          fill_in 'Item or Time Slot', with: 'BEST COOKIES'
          click_button 'Save'
        end
      end

      it { should have_selector('td', text: 'BEST COOKIES') }
    end

  end
end
