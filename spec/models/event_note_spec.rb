require 'rails_helper'

describe EventNote do
  let(:event_note) { FactoryGirl.build(:event_note) }
  subject { event_note }

  it { should respond_to(:note) }
  it { should respond_to(:havent_responded) }
  it { should respond_to(:rsvp_yes) }
  it { should respond_to(:rsvp_no) }
  it { should respond_to(:rsvp_maybe) }
  it { should respond_to(:all_pod_members) }
  it { should respond_to(:event_id) }
  it { should_not be_valid }

  it { should validate_presence_of(:note) }

  describe 'is valid when at least one box is checked' do
    before { event_note.rsvp_yes = '1' }
    it { should be_valid }
  end

end
