require 'rails_helper'

describe Event do
  let(:event) { FactoryGirl.build(:event) }
  subject { event }

  it { should respond_to(:city) }
  it { should respond_to(:completed) }
  it { should respond_to(:description) }
  it { should respond_to(:end_date) }
  it { should respond_to(:end_time) }
  it { should respond_to(:location) }
  it { should respond_to(:name) }
  it { should respond_to(:notify_members_of_update) }
  it { should respond_to(:organizer_id) }
  it { should respond_to(:organizer) }
  it { should respond_to(:phone) }
  it { should respond_to(:pod_id) }
  it { should respond_to(:pod) }
  it { should respond_to(:require_rsvp) }
  it { should respond_to(:start_date) }
  it { should respond_to(:start_time) }
  it { should respond_to(:time_zone) }
  it { should respond_to(:state) }
  it { should respond_to(:street) }
  it { should respond_to(:zipcode) }
  it { should respond_to(:confirmed) }
  it { should respond_to(:confirmed_at) }

  it { should belong_to(:organizer) }
  it { should belong_to(:pod) }
  it { should have_many(:rsvps).dependent(:destroy) }
  it { should have_many(:users).through(:rsvps) }
  it { should have_many(:rsvp_reminders).dependent(:destroy) }
  it { should have_many(:event_reminders).dependent(:destroy) }

  it { should accept_nested_attributes_for(:event_reminders) }
  it { should accept_nested_attributes_for(:rsvp_reminders) }

  # on create, don't validate
  it { should_not validate_presence_of(:name) }
  it { should_not validate_presence_of(:description) }
  it { should_not validate_presence_of(:location) }
  it { should_not validate_presence_of(:start_date) }
  it { should_not validate_presence_of(:start_time) }
  it { should_not validate_presence_of(:time_zone) }

  describe 'on update' do
    before { event.save! }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:time_zone) }
    it { should ensure_length_of(:name).is_at_most(40) }
  end

  it { should ensure_length_of(:zipcode).is_equal_to(5) }

  it 'is valid when end_date and end_time are blank' do
    should be_valid
  end

  describe 'validates end_date if end_time present' do
    before do
      event.end_time = '12:00 PM'
      event.save
    end
    it { should_not be_valid }
  end

  describe 'validates end_time if end_date present' do
    before do
      event.end_date = '2013-1-12'
      event.save
    end
    it { should_not be_valid }
  end

  describe 'is valid when both end_date and end_time are present' do
    before do
      event.end_date = '2028-1-12'
      event.end_time = '12:00 PM'
    end
    it { should be_valid }
  end

  describe 'end date must be greater than or equal to start date' do
    describe 'when dates are equal' do
      before { event.end_date = event.start_date }
      describe 'when times are equal' do
        before { event.end_time = event.start_time }
        it { should be_valid }
      end
      describe 'when end_time is later than start_time' do
        before { event.end_time = event.start_time + 1.minute }
        it { should be_valid }
      end
      describe 'when start_time is later than end_time' do
        before { event.end_time = event.start_time - 1.minute }
        it { should_not be_valid }
      end
    end
    describe 'is not valid when end_date is greater than start_date' do
      before { event.end_date = event.start_date - 1.day }
      it { should_not be_valid }
    end
  end

  describe 'start date cannot be in the past' do
    before { event.start_date = DateTime.now - 2.days }
    it { should_not be_valid }
  end

  describe 'it is valid if start date/time is in the future' do
    before do
      Time.zone = event.time_zone
      event.start_date = Time.zone.now.to_date
      event.start_time = 5.minutes.from_now.in_time_zone(event.time_zone)
    end
    it { should be_valid }
  end

end
