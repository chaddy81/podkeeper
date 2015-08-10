require 'rails_helper'

describe Setting do
  let(:setting) { FactoryGirl.create(:setting) }
  subject { setting }

  it { should respond_to(:note_new_notice) }
  it { should respond_to(:note_urgent_notice) }
  it { should respond_to(:note_reply_to_you_notice) }
  it { should respond_to(:note_reply_to_any_notice) }
  it { should respond_to(:event_new_notice) }
  it { should respond_to(:event_update_notice) }
  it { should respond_to(:event_reminder_notice) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should be_valid }

  it { should belong_to(:pod) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:pod_id) }
  it { should validate_presence_of(:user_id) }

end