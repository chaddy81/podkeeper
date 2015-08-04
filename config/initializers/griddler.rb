require "email_processor"

Griddler.configure do |config|
  config.processor_class = EmailProcessor # MyEmailProcessor
  if Rails.env.development?
    config.email_service = :mandrill # :cloudmailin, :postmark, :mandrill, :mailgun
  else
    config.email_service = :sendgrid # :cloudmailin, :postmark, :mandrill, :mailgun
  end
  config.reply_delimiter = ['-- REPLY ABOVE THIS LINE --', 'From:']
end