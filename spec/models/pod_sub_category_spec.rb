require 'rails_helper'

describe PodSubCategory do
  let(:pod_sub_category) { FactoryGirl.create(:pod_sub_category) }
  subject { pod_sub_category }

  it { should respond_to(:name) }
  it { should respond_to(:display_name) }
  it { should respond_to(:pod_category_id) }
  it { should respond_to(:pod_category) }
  it { should be_valid }

  it { should belong_to(:pod_category) }
  it { should have_many(:pods) }
end