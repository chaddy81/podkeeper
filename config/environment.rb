# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

#Setup mail config stuff
if Rails.env.development?
  ActionMailer::Base.smtp_settings = {
    user_name:            'podanize',
    password:             'e8q80YwXz7mk',
    domain:               'podanize.herokuapp.com',
    address:              'smtp.sendgrid.net',
    port:                 587,
    authentication:       'plain',
    enable_starttls_auto: true
  }

else

  ActionMailer::Base.smtp_settings = {
    user_name:            'pod2',
    password:             'NSlR7KbULiVi',
    domain:               'podkeeper.com',
    address:              'smtp.sendgrid.net',
    port:                 587,
    authentication:       'plain',
    enable_starttls_auto: true
  }

end
