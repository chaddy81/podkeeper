class InviteRequest < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :email,      presence:   true,
                         format:     { with: VALID_EMAIL_REGEX },
                         uniqueness: { message: 'Thanks, but we\'ve already got you!' }

  after_validation :downcase_email

  def downcase_email
    self.email.downcase! if self.email.present?
  end

end