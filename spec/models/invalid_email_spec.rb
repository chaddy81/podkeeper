require 'rails_helper'

describe InvalidEmail do
  let(:invalid_email) { FactoryGirl.build(:invalid_email) }
  subject { invalid_email }

  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should respond_to(:email) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:pod) }

end