require 'rails_helper'

describe Rsvp do
  let(:rsvp) { FactoryGirl.build(:rsvp) }
  let!(:no_rsvp_option) { FactoryGirl.create(:rsvp_option, name: 'no') }
  subject { rsvp }

  it { should respond_to(:comments) }
  it { should respond_to(:event_id) }
  it { should respond_to(:event) }
  it { should respond_to(:number_of_adults) }
  it { should respond_to(:number_of_kids) }
  it { should respond_to(:rsvp_option_id) }
  it { should respond_to(:rsvp_option) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should be_valid }

  it { should validate_presence_of(:event_id) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:rsvp_option_id) }

  it { should validate_numericality_of(:number_of_adults) }
  it { should validate_numericality_of(:number_of_kids) }

  it { should belong_to(:user) }
  it { should belong_to(:event) }
  it { should belong_to(:rsvp_option) }

  describe 'it defaults number of kids to 0' do
    before do
      rsvp.number_of_kids = ' '
      rsvp.number_of_adults = 1
      rsvp.rsvp_option = RsvpOption.yes
      rsvp.save!
    end
    specify { rsvp.number_of_kids.should == 0 }
  end

  describe 'it defaults number of adults to 0' do
    before do
      rsvp.number_of_kids = 1
      rsvp.number_of_adults = ' '
      rsvp.rsvp_option = RsvpOption.yes
      rsvp.save!
    end
    specify { rsvp.number_of_adults.should == 0 }
  end

  describe 'it validates at least one adult or one child attends' do
    before { rsvp.rsvp_option = RsvpOption.yes }
    describe 'kids and adults are coming' do
      before do
        rsvp.number_of_kids = 1
        rsvp.number_of_adults = 1
      end
      it { should be_valid }
    end
    describe 'only kids are coming' do
      before do
        rsvp.number_of_adults = 0
        rsvp.number_of_kids = 1
      end
      it { should be_valid }
    end
    describe 'only adults are coming' do
      before do
        rsvp.number_of_adults = 1
        rsvp.number_of_kids = 0
      end
      it { should be_valid }
    end
    describe 'neither kids nor adults are coming' do
      before do
        rsvp.number_of_adults = 0
        rsvp.number_of_kids = 0
      end
      it { should_not be_valid }
    end
  end

end