require 'rails_helper'

describe InviteRequest do
  let(:invite_request) { FactoryGirl.build(:invite_request) }
  subject { invite_request }

  it { should respond_to(:email) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should be_valid }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).with_message('Thanks, but we\'ve already got you!') }

end