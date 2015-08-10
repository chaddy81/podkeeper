require 'rails_helper'

describe RsvpReminder do
  let(:rsvp_reminder) { FactoryGirl.build(:rsvp_reminder) }
  subject { rsvp_reminder }

  it { should respond_to(:days_before) }
  it { should respond_to(:event_id) }
  it { should respond_to(:event) }
  it { should be_valid }

  it { should belong_to(:event) }

  it { should validate_presence_of(:days_before) }
  it { should validate_numericality_of(:days_before).only_integer }

end
