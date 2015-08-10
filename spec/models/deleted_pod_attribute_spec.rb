require 'rails_helper'

describe DeletedPodAttribute do
  let(:deleted_pod_attribute) { FactoryGirl.create(:deleted_pod_attribute) }
  subject { deleted_pod_attribute }

  it { should respond_to(:creator_first_name) }
  it { should respond_to(:creator_last_name) }
  it { should respond_to(:creator_id) }
  it { should respond_to(:creator) }
  it { should respond_to(:deleter_first_name) }
  it { should respond_to(:deleter_last_name) }
  it { should respond_to(:deleter_first_name) }
  it { should respond_to(:deleter_id) }
  it { should respond_to(:deleter) }
  it { should respond_to(:number_of_comments) }
  it { should respond_to(:number_of_discussions) }
  it { should respond_to(:number_of_documents) }
  it { should respond_to(:number_of_members) }
  it { should respond_to(:number_of_open_invites) }
  it { should respond_to(:number_of_past_events) }
  it { should respond_to(:number_of_pod_admins) }
  it { should respond_to(:number_of_task_lists) }
  it { should respond_to(:number_of_tasks) }
  it { should respond_to(:number_of_upcoming_events) }
  it { should respond_to(:pod_created_at) }
  it { should respond_to(:pod_deleted_at) }
  it { should respond_to(:pod_name) }
  it { should be_valid }

  it { should belong_to(:creator) }
  it { should belong_to(:deleter) }

  it { should validate_presence_of(:pod_name) }
  it { should validate_presence_of(:creator) }
  it { should validate_presence_of(:deleter) }

  it { should validate_numericality_of(:number_of_comments).only_integer }
  it { should validate_numericality_of(:number_of_discussions).only_integer }
  it { should validate_numericality_of(:number_of_documents).only_integer }
  it { should validate_numericality_of(:number_of_members).only_integer }
  it { should validate_numericality_of(:number_of_open_invites).only_integer }
  it { should validate_numericality_of(:number_of_past_events).only_integer }
  it { should validate_numericality_of(:number_of_upcoming_events).only_integer }
  it { should validate_numericality_of(:number_of_pod_admins).only_integer }
  it { should validate_numericality_of(:number_of_task_lists).only_integer }
  it { should validate_numericality_of(:number_of_tasks).only_integer }

  it { should allow_value('', nil).for(:number_of_comments) }
  it { should allow_value('', nil).for(:number_of_discussions) }
  it { should allow_value('', nil).for(:number_of_documents) }
  it { should allow_value('', nil).for(:number_of_members) }
  it { should allow_value('', nil).for(:number_of_open_invites) }
  it { should allow_value('', nil).for(:number_of_past_events) }
  it { should allow_value('', nil).for(:number_of_upcoming_events) }
  it { should allow_value('', nil).for(:number_of_pod_admins) }
  it { should allow_value('', nil).for(:number_of_task_lists) }
  it { should allow_value('', nil).for(:number_of_tasks) }

end