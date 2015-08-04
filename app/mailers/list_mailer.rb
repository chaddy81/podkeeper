class ListMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'PodKeeper <podmember@email.podkeeper.com>'

  def notification(list, user)
    @user = user
    @twolines = true
    @list = list
    mail to: "#{user.full_name} <#{user.email}>",
         subject: "A new List has been created for #{list.pod.name}"
  end

end