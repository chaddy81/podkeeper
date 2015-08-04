class DailyDigestMailer < ActionMailer::Base
  helper :mail
  include MailHelper
  layout 'mailer'
  default from: 'PodKeeper <podmember@email.podkeeper.com>'

  helper :application # for use in mailer views
  include ApplicationHelper # for use in mailer
  helper :events

  def daily_digest user
    @pod_memberships = user.pod_memberships
    @user = user
    @email = user.email

    mail to: user.email,
         subject: "Daily Digest of #{Time.now.strftime('%A, %B %d')}"
  end
end