require 'rails_helper'

describe List do
  let(:list) { FactoryGirl.build(:list) }
  subject { list }

  it { should respond_to(:creator_id) }
  it { should respond_to(:creator) }
  it { should respond_to(:details) }
  it { should respond_to(:list_type_id) }
  it { should respond_to(:list_type) }
  it { should respond_to(:name) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should respond_to(:notification_has_been_sent) }
  it { should be_valid }

  it { should have_many(:list_items) }
  it { should belong_to(:creator) }
  it { should belong_to(:list_type) }
  it { should belong_to(:pod) }

  it { should validate_presence_of(:list_type) }
  it { should validate_presence_of(:name) }

end
