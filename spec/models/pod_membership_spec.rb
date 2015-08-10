require 'rails_helper'

describe PodMembership do
  let(:pod_membership) { FactoryGirl.build(:pod_membership) }
  subject { pod_membership }

  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should respond_to(:get_ready_bar_expanded) }
  it { should respond_to(:access_level_id) }
  it { should respond_to(:access_level) }
  it { should respond_to(:deleted_at) }
  it { should be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:pod) }
  it { should belong_to(:access_level) }
  it { should have_many(:uploaded_files).dependent(:destroy) }

  describe 'reset_get_ready_bar_visibility' do
    let!(:pod_created_14_days_ago) { FactoryGirl.create(:pod, created_at: 14.days.ago) }
    let!(:pod_created_16_days_ago) { FactoryGirl.create(:pod, created_at: 16.days.ago) }
    let!(:pod_membership_1) { FactoryGirl.create(:pod_membership, get_ready_bar_expanded: false, pod: pod_created_14_days_ago) }
    let!(:pod_membership_2) { FactoryGirl.create(:pod_membership, get_ready_bar_expanded: true, pod: pod_created_16_days_ago) }
    before { PodMembership.reset_get_ready_bar_visibility }
    specify { pod_membership_2.get_ready_bar_expanded.should eq(true) }
    specify { pod_membership_1.get_ready_bar_expanded.should eq(false) }
  end

  # describe 'non member joins pod' do
  #   let!(:pm) { FactoryGirl.create(:pod_membership) }
  #   let!(:comment) { FactoryGirl.create(:comment, invite_id: 1)}
  #   let!(:note) { FactoryGirl.create(:note, pod_id: pm.pod.id, user_id: pm.user.id, token: '123abc')}

  #   before do
  #     comment.note_id = note.id
  #     note.comment_id = comment.id
  #     pm.reassign_comments(pm.user)
  #   end

  #   context 'reassigns comments to new user' do
  #     specify { comment.user_id.should_not eq(nil) }
  #   end

  # end

end