module SessionsHelper

  def sign_in(user, remember)
    if remember
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def current_user?(user)
    user == current_user
  end

  def current_pod
    @current_pod ||= Pod.where(id: session[:pod_id]).first unless session[:pod_id].blank?
  end

  def current_pod=(pod)
    @current_pod=pod
  end

  def current_pod?(pod)
    pod == current_pod
  end

  def set_current_pod(pod)
    return if current_pod?(pod)
    if pod
      @current_pod = pod
      session[:pod_id] = pod.id
      current_user.record_last_pod!(pod.id)
    else
      @current_pod = nil
      session[:pod_id] = nil
    end
  end

  def current_pod_exists
    render_404 and return if current_pod.nil?
  end

  def signed_in_user
    if signed_in?
      @sign_in_date ||= DateTime.now
    else signed_in?
      store_location
      respond_to do |format|
        format.html { redirect_to signin_path, notice: 'Please sign in.' }
        format.js { render js: "window.location = '/signin'" }
      end
    end
  end

  def admin_only
    render_404 unless current_user.is_admin?
  end

  def sign_out
    cookies.delete(:auth_token)
    reset_session
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def store_location(location = request.fullpath)
    session[:return_to] = location
  end

  private

  def clear_return_to
    session[:return_to] = nil
    session.delete(:return_to)
  end

end
