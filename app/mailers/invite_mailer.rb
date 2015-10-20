class InviteMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'PodKeeper <podmember@email.podkeeper.com>'

  def create_pod_invite(invite)
    @invite = invite
    @is_member = User.find_by_email(invite.email).present?
    @reminder = false
    @email = invite.email
    mail to: invite.email,
         subject: "Invitation to create a #{invite.pod_name} Pod on PodKeeper.com",
         reply_to: invite.inviter.email,
         from: "#{invite.inviter.full_name} <podmember@email.podkeeper.com>"
  end

  def create_a_pod_reminder(invite)
    @invite = invite
    @is_member = User.find_by_email(invite.email).present?
    @reminder = true
    @email = invite.email
    mail to: invite.email,
         subject: "Reminder: Invitation from #{invite.inviter.full_name} to create a Pod on PodKeeper.com",
         template_name: 'create_pod_invite'
  end

  def pod_invite(invite)
    @invite = invite
    @email = invite.email
    @oneline = true
    mail to: invite.email,
         subject: "Invitation to join Pod - #{invite.pod.name}",
         reply_to: invite.inviter.email,
         from: "#{invite.inviter.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def reminder(invite)
    @invite = invite
    @email = invite.email
    @oneline = true
    mail to: invite.email,
         subject: 'PodKeeper Invite Reminder',
         reply_to: invite.inviter.email
  end

  def send_invite_to_create_a_pod_four_day_reminder(invite)
    @invite = invite
    @is_member = User.find_by_email(invite.email).present?
    @email = invite.email
    if invite.pod_name.blank?
      subject = 'Reminder to create a Pod on PodKeeper'
    else
      subject = "Reminder to create a #{invite.pod_name} Pod on PodKeeper"
    end
    mail to: invite.email,
         subject: subject,
         reply_to: invite.inviter.email,
         from: "#{invite.inviter.full_name} <podmember@email.podkeeper.com>"
  end

  def send_invite_to_create_a_pod_eleven_day_reminder(invite)
    @invite = invite
    @is_member = User.find_by_email(invite.email).present?
    @email = invite.email
    if invite.pod_name.blank?
      subject = 'FINAL reminder to create a Pod on PodKeeper'
    else
      subject = "FINAL reminder to create a #{invite.pod_name} Pod on PodKeeper"
    end
    mail to: invite.email,
         subject: subject,
         reply_to: invite.inviter.email,
         from: "#{invite.inviter.full_name} <podmember@email.podkeeper.com>"
  end

  def send_invite_to_join_a_pod_two_day_reminder(invite)
    @invite = invite
    @final_reminder = false
    @email = invite.email
    mail to: invite.email,
         subject: "Reminder - Invitation to join Pod - #{@invite.pod.name}",
         template_name: 'pod_invite_reminder',
         reply_to: invite.inviter.email,
         from: "#{invite.inviter.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def send_invite_to_join_a_pod_four_day_reminder(invite)
    @invite = invite
    @final_reminder = false
    @email = invite.email
    mail to: invite.email,
         subject: "Take one minute to join Pod - #{@invite.pod.name}",
         reply_to: invite.inviter.email,
         from: "#{invite.inviter.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def send_invite_to_join_a_pod_nine_day_reminder(invite)
    @invite = invite
    @final_reminder = true
    @email = invite.email
    mail to: invite.email,
         subject: "FINAL Reminder - Invitation to join Pod - #{@invite.pod.name}",
         template_name: 'pod_invite_reminder',
         reply_to: invite.inviter.email,
         from: "#{invite.inviter.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def invite_request(invite_request)
    @invite_request = invite_request
    @email = 'podinfo@podkeeper.com'
    mail to: @email,
         subject: 'New Private Beta Signup'
  end

end