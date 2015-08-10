require 'rails_helper'

describe Invite do
  let(:invite) { FactoryGirl.build(:site_invite) }
  subject { invite }

  it { should respond_to(:email) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:invitee_id) }
  it { should respond_to(:invitee) }
  it { should respond_to(:inviter_id) }
  it { should respond_to(:inviter) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should respond_to(:pod_name) }
  it { should be_valid }

  it { should belong_to(:pod) }
  it { should belong_to(:invitee) }
  it { should belong_to(:inviter) }
  it { should have_many(:reminders).dependent(:destroy) }

  it { should validate_presence_of(:email) }

  describe 'user is blank on invite build' do
    let!(:user)   { FactoryGirl.create(:user) }
    let(:invite) { FactoryGirl.build(:site_invite, email: user.email) }
    specify { invite.invitee_id.should eq(nil) }
    describe 'but is assigned to user after create if email exists in system' do
      before { invite.save! }
      specify { invite.invitee.should eq(user) }
    end
  end

end