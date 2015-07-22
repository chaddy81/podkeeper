class SiteComment < ActiveRecord::Base
  attr_accessible :body, :user_id, :user

  belongs_to :user

  validates :body, presence: true

  after_create :send_email

  private

  def send_email
    NoteMailer.delay.new_site_comment(self)
  end

end
