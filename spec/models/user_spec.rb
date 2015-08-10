require 'rails_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it { should respond_to(:active) }
  it { should respond_to(:first_name) }
  it { should respond_to(:email) }
  it { should respond_to(:is_admin) }
  it { should respond_to(:last_login) }
  it { should respond_to(:last_name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:phone) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:testing_password) }
  it { should respond_to(:time_zone) }
  it { should be_valid }

  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:deleted_pod_attributes_as_creator) }
  it { should have_many(:deleted_pod_attributes_as_deleter) }
  it { should have_many(:kids).dependent(:destroy) }
  it { should have_many(:lists) }
  it { should have_many(:list_items).dependent(:destroy) }
  it { should have_many(:notes).dependent(:destroy) }
  it { should have_many(:pod_memberships).dependent(:destroy) }
  it { should have_many(:invalid_emails).dependent(:destroy) }
  it { should have_many(:rsvps).dependent(:destroy) }
  it { should have_many(:settings).dependent(:destroy) }
  it { should have_many(:site_comments).dependent(:destroy) }
  it { should have_many(:pods_as_organizer) }
  it { should have_many(:sent_invites) }
  it { should have_many(:events_as_organizer) }
  it { should have_many(:received_invites) }
  it { should have_many(:pods).through(:pod_memberships) }
  it { should have_many(:events).through(:rsvps) }

  #it { should validate_presence_of(:first_name) }
  #it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:time_zone) }

  it { should validate_uniqueness_of(:email) }

  #describe 'when testing password' do
    #before { user.testing_password = true }
    #it { should validate_presence_of(:password_confirmation) }
    #it { should ensure_length_of(:password_confirmation).is_at_least(6).is_at_most(128) }

    #describe 'after user has been saved' do
      #before { user.save! }
      #it { should validate_presence_of(:password_confirmation) }
      #it { should ensure_length_of(:password_confirmation).is_at_least(6).is_at_most(128) }
    #end
  #end

  #describe 'when not testing password' do
    #before { user.testing_password = false }
    #it { should_not validate_presence_of(:password) }
    #it { should_not validate_presence_of(:password_confirmation) }
  #end

  describe 'creates user setting' do
    let(:pod_membership) { FactoryGirl.build(:pod_membership) }
    let!(:settings_count) { Setting.count }

    describe 'when saved' do
      before { pod_membership.save! }
      specify { Setting.count.should eq(settings_count + 1) }
    end
  end

  context "user creation" do

    describe 'empty names' do
      let(:user1) { FactoryGirl.build(:user) }

      it "sets first_name to an empty string" do
        user1.first_name = nil
        user1.last_name = nil
        user1.save
        expect(user1.first_name).to eq('')
        expect(user1.last_name).to eq('')
      end

      it "does not set to an empty string if value exists" do
        user1.first_name = nil
        user1.save
        expect(user1.first_name).to eq('')
        expect(user1.last_name).to eq('Johnson')
      end
    end
  end

end
