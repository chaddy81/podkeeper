class SessionsController < ApplicationController
  skip_before_filter :signed_in_user

  layout 'registration', only: :new

  def new
    session[:view_count] = 0
    if signed_in?
      flash.keep
      if current_user.pods.any?
        last_pod_visited = Pod.find(current_user.last_pod_visited_id)
        current_pod = last_pod_visited
        if last_pod_visited.nil?
          # redirect_to dashboard_pod_path(current_user.pods.order('created_at').first)
        else
          redirect_to events_path
        end

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
    session[:view_count] = 0
    if params[:provider].present?
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
            pod = Pod.where(id: user.last_pod_visited_id).first || user.pods.last
            pod.present? ? redirect_back_or(events_path(login: 'success')) : redirect_to(new_pod_path)
          else
            puts user.errors.full_messages
          end
        else
          user = User.from_omniauth(auth)
          sign_in user, params[:remember_me]
          user.update_attribute :last_login, DateTime.now
          pod = Pod.where(id: user.last_pod_visited_id).first || user.pods.last
          pod.present? ? redirect_back_or(events_path(login: 'success')) : redirect_to(new_pod_path)
        end
      end
    else
      user = User.find_by_email(params[:email].downcase)
      if user && user.authenticate(params[:password]) && user.active?
        sign_in user, params[:remember_me]
        user.update_attribute :last_login, DateTime.now
        pod = Pod.where(id: user.last_pod_visited_id).first || user.pods.last
        pod.present? ? redirect_back_or(events_path) : redirect_to(new_pod_path)
      else
        session[:email] = params[:email]
        session[:login] = "failure"
        flash[:error] = 'Invalid email address/password combination'
        redirect_to :back
      end
    end
  end

  def destroy
    puts cookies[:auth_token]
    sign_out
    redirect_to root_path
  end

end
