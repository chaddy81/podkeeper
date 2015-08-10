require 'rails_helper'

describe EventReminder do
  let(:event_reminder) { FactoryGirl.build(:event_reminder) }
  subject { event_reminder }

  it { should respond_to(:days_before) }
  it { should respond_to(:event_id) }
  it { should respond_to(:event) }
  it { should be_valid }

  it { should belong_to(:event) }

  it { should validate_presence_of(:days_before) }
  it { should validate_numericality_of(:days_before).only_integer }

end
