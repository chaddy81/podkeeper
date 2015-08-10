require 'rails_helper'

describe Kid do
  let(:kid) { FactoryGirl.build(:kid) }
  subject { kid }

  it { should respond_to(:name) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should be_valid }

  it { should belong_to(:pod) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }

end