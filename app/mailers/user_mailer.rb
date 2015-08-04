class UserMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'PodKeeper <podmember@email.podkeeper.com>'

  def new_user_welcome(user)
    @user = user
    @email = user.email
    mail to: "#{user.full_name} <#{user.email}>",
         subject: 'Welcome to PodKeeper',
         template_path: 'mailers'
  end

  def password_reset(user)
    @user = user
    mail to: user.email,
         subject: 'PodKeeper Password Reset',
         template_path: 'mailers'
  end

end