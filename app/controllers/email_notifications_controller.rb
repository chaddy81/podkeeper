class EmailNotificationsController < ApplicationController
  skip_before_filter :signed_in_user

  def create
    email_notifications = params['_json']

    email_notifications.each do |email_notification|
      email = EmailNotification.new

      email.email = email_notification[:email]
      email.smtp_id = email_notification['smtp-id']
      email.timestamp = email_notification[:timestamp]
      email.ip = email_notification[:ip]
      email.sg_message_id = email_notification[:sg_message_id]
      email.sg_event_id = email_notification[:sg_event_id]
      email.useragent = email_notification[:useragent]
      email.event = email_notification[:event]
      email.url = email_notification[:url]

      email.save!
    end

    render json: 'Success', status: :ok
  end
end
