require 'rails_helper'

describe ListItem do
  let(:list_item) { FactoryGirl.build(:list_item) }
  subject { list_item }

  it { should respond_to(:item) }
  it { should respond_to(:list_id) }
  it { should respond_to(:list) }
  it { should respond_to(:notes) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:row_number) }
  it { should respond_to(:sign_me_up) }
  it { should be_valid }

  it { should belong_to(:user) }
  it { should belong_to(:list) }

  it { should validate_presence_of(:item) }

end
