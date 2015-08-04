class PodMailer < ActionMailer::Base
  layout 'mailer'
  default from: 'PodKeeper <podmember@email.podkeeper.com>'

  def pod_creation_confirmation(pod)
    @pod = pod
    @user = pod.organizer
    @email = pod.organizer.email
    mail to: "#{pod.organizer.full_name} <#{pod.organizer.email}>",
         subject: "Your #{pod.name} Pod has been created"
  end

  def join_pod_confirmation(pod, user)
    @pod = pod
    @user = user
    @email = user.email
    mail to: "#{user.full_name} <#{user.email}>",
         subject: "You've joined this Pod - #{pod.name}"
  end

  def pod_deleted(pod, user, deleter)
    @pod = pod
    @user = user
    @sender = deleter
    @email = user.email
    mail to: "#{user.full_name} <#{user.email}>",
         subject: "I have closed this Pod - #{pod.name}",
         reply_to: deleter.email,
         from: "#{deleter.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def you_removed_yourself_from_pod(pod_membership)
    @pod_membership = pod_membership
    @user = pod_membership.user
    @email = pod_membership.user.email
    mail to: "#{pod_membership.user.full_name} <#{@email}>",
         subject: "Update from #{pod_membership.pod.name}"
  end

  def you_were_removed_from_pod(pod_membership, remover)
    @pod_membership = pod_membership
    @email = pod_membership.user.email
    @user = pod_membership.user
    @sender = remover
    mail to: "#{pod_membership.user.full_name} <#{@email}>",
         subject: "Update from #{pod_membership.pod.name}",
         reply_to: remover.email,
         from: "#{remover.full_name} via PodKeeper <podmember@email.podkeeper.com>"
  end

  def access_level_changed(old_access_level, new_access_level, pod_membership)
    @pod_membership = pod_membership
    @email = pod_membership.user.email
    @user = pod_membership.user
    @new_access_level = new_access_level
    @old_access_level = old_access_level
    mail to: "#{pod_membership.user.full_name} <#{@email}>",
         subject: "Change in your Pod Admin rights for #{pod_membership.pod.name}"
  end

  def new_pod_organizer(pod, last_organizer)
    @pod = pod
    @last_organizer = last_organizer
    @email = @pod.organizer.email
    mail to: "#{pod.organizer.full_name} <#{@email}>",
         subject: "You have been named the new organizer - #{pod.organizer.full_name}"
  end

end