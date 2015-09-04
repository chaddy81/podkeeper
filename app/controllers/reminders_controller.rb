class RemindersController < ApplicationController

  def create
    invite_ids = params[:reminders] || []
    invite_ids.each do |invite_id, _|
      invite = Invite.find(invite_id)
      invite.reminders.create
      if invite.pod_id.nil?
        InviteMailer.delay.create_a_pod_reminder(invite)
      else
        InviteMailer.delay.reminder(invite)
      end
    end
    if invite_ids.any?
      flash[:success] = 'Invitation reminders were sent successfully!'
    else
      flash[:warning] = 'No reminders were selected, so none were sent'
    end

    invited_users = current_pod.invites.unaccepted
    invited_users_with_only_first_name = invited_users.where("(last_name IS NULL OR last_name = '') AND (first_name IS NOT NULL AND first_name != '')").order(:first_name)
    invited_users_with_only_last_name = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NOT NULL AND last_name != '')").order(:last_name)
    invited_users_with_only_email = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NULL OR last_name = '')").order(:email)
    invited_users_with_all_info = invited_users - (invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email)
    @outstanding_invites = invited_users_with_all_info + invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email

    redirect_to invite_others_path
  end

end
