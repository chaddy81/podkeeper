require 'rails_helper'

describe PodCategory do
  let(:pod_category) { FactoryGirl.create(:pod_category) }
  subject { pod_category }

  it { should respond_to(:name) }
  it { should respond_to(:display_name) }
  it { should be_valid }

  it { should have_many(:pods) }
  it { should have_many(:pod_sub_categories) }
end