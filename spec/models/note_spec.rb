require 'rails_helper'

describe Note do
  let(:note) { FactoryGirl.build(:note) }
  subject { note }

  it { should respond_to(:topic) }
  it { should respond_to(:event_id) }
  it { should respond_to(:event) }
  it { should respond_to(:body) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should respond_to(:is_urgent) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:sort_by_date) }
  it { should be_valid }

  it { should belong_to(:event) }
  it { should belong_to(:user) }
  it { should belong_to(:pod) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of(:topic) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should ensure_length_of(:topic).is_at_most(60) }

end