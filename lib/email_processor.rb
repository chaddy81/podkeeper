class EmailProcessor

  def self.process(email)
    new(email).process
  end

  def initialize(email)
    @email = email
  end

  def process
    create_comment
  end

  private
  attr_accessor :email

  def create_comment
    begin
      discussion_token = email.to.first[:token].split('-')[1]
      note = Note.find_by_token(discussion_token).id
      email_body = email.body

      if User.find_by_email(email.from)
        email_from = User.find_by_email(email.from).id
        Comment.create(user_id: email_from, note_id: note, body: email_body)
      # else
      #   email_from = Invite.find_by_email(email.from).id
      #   Comment.create(invite_id: email_from, note_id: note, body: email_body)
      end
    rescue => e
      puts e
    end
  end

  def sanitized_body
    Sanitize.clean(email.body, Sanitize::Config::BASIC)
  end

end