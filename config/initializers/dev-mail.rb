if Rails.env == 'development' || Rails.env == 'test'

  class OverrideMailRecipient
    def self.delivering_email(mail)
      mail.to = "chad@entrision.com"
    end
  end

  ActionMailer::Base.register_interceptor(OverrideMailRecipient)
end
