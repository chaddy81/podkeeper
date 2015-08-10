require 'rails_helper'

describe AccessLevel do
  let(:access_level) { FactoryGirl.build(:access_level) }
  subject { access_level }

  it { should respond_to(:name) }
  it { should respond_to(:display_name) }

  it { should have_many(:pod_memberships) }

end
