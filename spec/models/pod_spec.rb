require 'rails_helper'

describe Pod do
  let!(:pod) { FactoryGirl.create(:pod) }
  subject { pod }

  it { should respond_to(:pod_category_id) }
  it { should respond_to(:pod_category) }
  it { should respond_to(:pod_sub_category_id) }
  it { should respond_to(:pod_sub_category) }
  it { should respond_to(:description) }
  it { should respond_to(:name) }
  it { should respond_to(:organizer_id) }
  it { should respond_to(:organizer) }
  it { should respond_to(:slug) }
  it { should respond_to(:deleted_at) }
  it { should be_valid }

  it { should have_many(:events).dependent(:destroy) }
  it { should have_many(:invites).dependent(:destroy) }
  it { should have_many(:invalid_emails).dependent(:destroy) }
  it { should have_many(:kids).dependent(:destroy) }
  it { should have_many(:lists).dependent(:destroy) }
  it { should have_many(:notes).dependent(:destroy) }
  it { should have_many(:users).through(:pod_memberships) }
  it { should have_many(:pod_memberships).dependent(:destroy) }
  it { should belong_to(:organizer) }
  it { should belong_to(:pod_category) }
  it { should belong_to(:pod_sub_category) }
  it { should accept_nested_attributes_for(:invites).allow_destroy(true) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:pod_category) }
  it { should validate_uniqueness_of(:slug) }
  it { should ensure_length_of(:name).is_at_most(50) }

  describe 'it creates a slug after creation' do
    before { pod.save! }
    specify { pod.slug.should_not eq(nil) }
  end

  describe 'requires sub category properly' do
    describe 'required when sports' do
      let(:pod_category) { FactoryGirl.build(:pod_category, name: 'sports') }
      before { pod.pod_category = pod_category }
      it { should validate_presence_of(:pod_sub_category) }
    end
    describe 'required when arts/music' do
      let(:pod_category) { FactoryGirl.build(:pod_category, name: 'arts_music') }
      before { pod.pod_category = pod_category }
      it { should validate_presence_of(:pod_sub_category) }
    end
    describe 'required when parents activity' do
      let(:pod_category) { FactoryGirl.build(:pod_category, name: 'parents_activity') }
      before { pod.pod_category = pod_category }
      it { should validate_presence_of(:pod_sub_category) }
    end
    describe 'NOT required when other' do
      let(:pod_category) { FactoryGirl.build(:pod_category, name: 'other') }
      before { pod.pod_category = pod_category }
      it { should_not validate_presence_of(:pod_sub_category) }
    end
    describe 'NOT required when blank' do
      before { pod.pod_category = nil }
      it { should_not validate_presence_of(:pod_sub_category) }
    end
  end

end
