class BulkInvitesController < ApplicationController

  def new
    invited_users = current_pod.invites.unaccepted.includes(:reminders)
    invited_users_with_only_first_name = invited_users.where("(last_name IS NULL OR last_name = '') AND (first_name IS NOT NULL AND first_name != '')").order(:first_name)
    invited_users_with_only_last_name = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NOT NULL AND last_name != '')").order(:last_name)
    invited_users_with_only_email = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NULL OR last_name = '')").order(:email)
    invited_users_with_all_info = invited_users - (invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email)
    @outstanding_invites = invited_users_with_all_info + invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email

    @invalid_emails = current_pod.invalid_emails.where(user_id: current_user.id)
  end

  def create
    @outstanding_invites = current_pod.invites.unaccepted.includes(:reminders)
    # @invalid_emails = current_pod.invalid_emails.where(user_id: current_user.id)
    @invalid_emails = InvalidEmail.where(pod_id: current_pod.id, user_id: current_user.id)
    if params[:emails].blank?
      flash.now[:error] = 'Please enter email addresses to import.'
      render :new and return
    else
      valid_emails, invalid_emails, already_invited_emails = [], [], []
      emails = params[:emails].split(/,|;/)
      emails.each do |email|
        words = email.split(' ')
        found = false
        words.each do |word|
          if word.include?('@')
            word = word.delete('<').delete('>').delete('"').delete("'").delete('(').delete(')')
            if word =~ VALID_EMAIL_REGEX
              found = true
              invite = current_user.sent_invites.create(email: word, pod_id: current_pod.id)
              if invite.new_record?
                already_invited_emails << word
              else
                valid_emails << word
                InviteMailer.delay.pod_invite(invite)
              end
            end
            break
          end
        end
        unless found || email.blank?
          invalid_emails << email
          current_user.invalid_emails.create(pod_id: current_pod.id, email: email)
        end
      end
    end
    flash[:success] = "#{view_context.pluralize valid_emails.count, 'invitation'} #{valid_emails.count == 1 ? 'was' : 'were'} sent successfully" if valid_emails.any?
    flash[:error] = "#{view_context.pluralize invalid_emails.count, 'invitation'} #{invalid_emails.count == 1 ? 'was' : 'were'} not sent. Check invalid email addresses at the bottom of the page." if invalid_emails.any?
    if already_invited_emails.any?
      if already_invited_emails.count == 1
        flash[:notice] = "1 person is either a Member or has been invited - #{already_invited_emails}"
      else
        flash[:notice] = "#{view_context.pluralize already_invited_emails.count, 'person'} are either Members or have been invited - #{already_invited_emails}"
      end
    end
    redirect_to new_bulk_invite_path
  end

end