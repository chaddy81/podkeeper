require 'rails_helper'

describe RsvpOption do
  let(:rsvp_option) { FactoryGirl.create(:rsvp_option) }
  subject { rsvp_option }

  it { should respond_to(:name) }
  it { should respond_to(:display_name) }
  it { should respond_to(:color) }

  it { should have_many(:rsvps) }
  it { should be_valid }

end