require 'rails_helper'

describe ListType do
  let(:list_type) { FactoryGirl.build(:list_type) }
  subject { list_type }

  it { should respond_to(:name) }
  it { should respond_to(:display_name) }
  it { should be_valid }

  it { should have_many(:lists) }

end