require 'rails_helper'

describe UploadedFile do
  let(:uploaded_file) { FactoryGirl.build(:uploaded_file) }
  subject { uploaded_file }

  it { should respond_to(:description) }
  it { should respond_to(:file) }
  it { should respond_to(:url) }
  it { should respond_to(:pod_membership_id) }
  it { should respond_to(:pod_membership) }
  it { should be_valid}

  it { should belong_to(:pod_membership) }

end