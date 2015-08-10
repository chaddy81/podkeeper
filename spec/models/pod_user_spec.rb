require 'rails_helper'

describe PodUser do
  let(:pod_user) { FactoryGirl.build(:pod_user) }
  subject { pod_user }

  it { should respond_to(:pod_category_id) }
  it { should respond_to(:pod_category) }
  it { should respond_to(:pod_sub_category_id) }
  it { should respond_to(:pod_sub_category) }
  it { should respond_to(:description) }
  it { should respond_to(:name) }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:phone) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:time_zone) }
  it { should respond_to(:invite_id) }
  it { should be_valid }

  # it { should belong_to(:pod_category) }
  # it { should belong_to(:pod_sub_category) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:pod_category_id) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  #it { should validate_presence_of(:password_confirmation) }

  #it { should validate_confirmation_of(:password) }
  #it { should ensure_length_of(:password_confirmation).is_at_least(6).is_at_most(128) }

  describe 'requires sub category properly' do
    describe 'required when sports' do
      let(:pod_category) { FactoryGirl.build(:pod_category, name: 'sports') }
      before { pod_user.pod_category = pod_category }
      it { should validate_presence_of(:pod_sub_category_id) }
    end
  end

  describe 'validates uniqueness of email' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:pod_user) { FactoryGirl.build(:pod_user, email: user.email) }
    it { should_not be_valid }
  end

end
