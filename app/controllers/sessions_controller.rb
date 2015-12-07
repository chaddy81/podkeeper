class SessionsController < ApplicationController
  skip_before_filter :signed_in_user

  layout 'registration', only: :new

  def new
    if signed_in?
      flash.keep
      if current_user.pods.any?
        last_pod_visited = Pod.find(current_user.last_pod_visited_id)
        set_current_pod(last_pod_visited)

        redirect_to events_path

      elsif current_user.received_invites.unaccepted.where('pod_id IS NOT NULL')
        redirect_to invites_path
      else
        redirect_to new_pod_path
      end
    else
      @pod_user = PodUser.new
    end

  end

  def create
    if params[:provider].present?
      invite = Invite.find_by_auth_token(env['omniauth.params']['auth_token']) if env['omniauth.params']['auth_token']
      auth = env["omniauth.auth"]

      if !auth.info.email
        flash[:error] = 'PodKeeper requires an email address to register. You can either Login with Facebook again and allow access to your email address, or join PodKeeper with an email address and password'
        redirect_to new_session_path
      else
        if User.find_by_email(auth.info.email)
          user = User.find_by_email(auth.info.email)
          user.update_omniauth(auth)

          if user.save
            sign_in user, true
            user.update_attribute :last_login, DateTime.now
            if user.time_zone.nil? || user.time_zone == 'none'
              user.update_attribute :time_zone, 'Eastern Time (US & Canada)'
            end

            if invite
              invite.accept!
              unless user.pods.include?(invite.pod) || invite.pod.nil?
                user.pod_memberships.create(pod: invite.pod, access_level: AccessLevel.member)
              end
              set_current_pod(user.pods.last)
            end

            pod = Pod.where(id: user.last_pod_visited_id).first || user.pods.last
            set_current_pod(pod)
            pod.present? ? redirect_back_or(events_path) : redirect_to(new_pod_path)
          else
            puts user.errors.full_messages
          end
        else
          user = User.from_omniauth(auth)
          sign_in user, params[:remember_me]
          UserMailer.delay.new_user_welcome(user)

          user.update_attribute :last_login, DateTime.now
          if user.time_zone.nil? || user.time_zone == 'none'
            user.update_attribute :time_zone, 'Eastern Time (US & Canada)'
          end

          if invite
            invite.accept!
            unless user.pods.include?(invite.pod) || invite.pod.nil?
              user.pod_memberships.create(pod: invite.pod, access_level: AccessLevel.member)
            end
            set_current_pod(user.pods.last)
          end

          pod = Pod.where(id: user.last_pod_visited_id).first || user.pods.last
          pod.present? ? redirect_back_or(events_path) : redirect_to(new_pod_path)
        end
      end
    else
      uri = session[:return_to].split('?').first if session[:return_to]
      user = User.find_by_email(params[:email].downcase)
      if user && user.authenticate(params[:password]) && user.active?
        sign_in user, params[:remember_me]
        user.update_attribute :last_login, DateTime.now
        if uri == '/invites'
          redirect_to invites_path
        else
          pod = user.pods.where(id: user.last_pod_visited_id).first || user.pods.last
          set_current_pod(pod)
          pod.present? ? redirect_back_or(events_path) : redirect_to(new_pod_path)
        end
      else
        session[:email] = params[:email]
        session[:login] = "failure"
        flash[:error] = 'Invalid email address/password combination'
        render :new
      end
    end
  end

  def destroy
    puts cookies[:auth_token]
    sign_out
    redirect_to root_path
  end

end
