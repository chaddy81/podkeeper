require 'rails_helper'

describe Reminder do
  let(:reminder) { FactoryGirl.build(:reminder) }
  subject { reminder }

  it { should respond_to(:invite_id) }
  it { should respond_to(:invite) }

  it { should belong_to(:invite) }
  it { should be_valid }

end