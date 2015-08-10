require 'rails_helper'

describe Invite do

  describe 'validates user is not already in pod' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:pod_membership) { FactoryGirl.create(:pod_membership, user: user) }
    let!(:invite) { FactoryGirl.build(:pod_invite, pod: pod_membership.pod, email: user.email) }
    specify { invite.should_not be_valid }
  end

end