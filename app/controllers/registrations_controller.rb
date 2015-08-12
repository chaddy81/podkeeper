class RegistrationsController < ApplicationController
  skip_before_filter :signed_in_user

  layout 'registration'

  def new
    if params[:auth_token]
      invite = Invite.find_by_auth_token(params[:auth_token])

      if signed_in?
        if current_user? invite.invitee
          redirect_to root_path and return
        else
          sign_out
          if invite.invitee.present?
            redirect_to invites_path
          else
            redirect_to signup_path(auth_token: params[:auth_token]) and return
          end
        end
      else
        @pod = invite.pod
        @user = User.new(email: invite.email,
                         first_name: invite.first_name,
                         last_name: invite.last_name,
                         invite_id: invite.id)
      end
    else
      @user = User.new
    end
  end

end
