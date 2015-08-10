require 'rails_helper'

describe EmailProcessor do
  let(:pod) { FactoryGirl.create(:pod, id: 1) }
  let(:user) { FactoryGirl.create(:user, id: 1, email: 'from_email@email.com') }

  # Create Note to reply to and create object to simulate an actual reply email to discussion
  before { @note = Note.create(body: 'This is a discussion', pod_id: pod.id, topic: 'Discussion', user_id: user.id)
           @email = OpenStruct.new
           @email.to = [{ full: "discussion-#{@note.token}@email.com", email: "discussion-#{@note.token}@email.com", token: "discussion-#{@note.token}", host: 'email.com', name: nil }]
           @email.from = 'from_email@email.com'
           @email.subject = 'Discussion - Pod Name'
           @email.body = 'Hello!' }

  it 'processes incoming discussion replies' do
    expect(@email.body).to eql('Hello!')
  end

  it 'creates comments' do
    # Comment count should equal zero as starting point
    expect(Comment.all.count).to eql(0)

    # Process email through Griddler
    EmailProcessor.new(@email).process

    # Comment body should equal email body
    expect(Comment.last.body).to eq('Hello!')
  end

end