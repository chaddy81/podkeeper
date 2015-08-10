require 'rails_helper'

describe Comment do
  let(:comment) { FactoryGirl.build(:comment) }
  subject { comment }

  it { should respond_to(:body) }
  it { should respond_to(:note_id) }
  it { should respond_to(:note) }
  it { should respond_to(:user_id) }
  it { should respond_to(:invite_id) }
  it { should respond_to(:user) }
  it { should be_valid }

  it { should belong_to(:note) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }
  # it { should validate_presence_of(:user_id) }
  # it { should validate_presence_of(:invite_id) }
  it { should validate_presence_of(:note_id) }

  describe 'testing conditional validations' do
    context 'should validate user_id' do
      before do
        comment.invite_id = nil
      end

      it { should validate_presence_of(:user_id) }
    end

    context 'should not validate user_id' do
      before do
        comment.invite_id = 1
      end

      it { should_not validate_presence_of(:user_id) }
    end

    context 'should validate invite_id' do
      before do
        comment.user_id = nil
      end

      it { should validate_presence_of(:invite_id) }
    end

    context 'should not validate invite_id' do
      before do
        comment.user_id = 1
      end

      it { should_not validate_presence_of(:invite_id) }
    end
  end

  describe 'updates note sorting timestamp after save' do
    before { comment.save }
    let(:note_sort_by_date) { comment.note.sort_by_date }
    describe 'saving comment' do
      before { comment.save }
      specify { comment.note.sort_by_date.should_not eq(:note_sort_by_date) }
    end
  end

  describe 'non member becomes member' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      comment.convert_to_user_comment(user.id)
    end

    context 'converts comments to user comments' do
      specify { comment.user_id.should_not eq(nil) }
    end
  end

  describe 'member becomes non member' do

    before do
      comment.convert_to_invite_comment
    end

    context 'converts comments to invite comments' do
      specify { comment.user_id.should eq(nil) }
    end
  end

end
