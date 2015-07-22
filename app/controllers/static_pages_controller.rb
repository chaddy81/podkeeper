class StaticPagesController < ApplicationController
  skip_before_filter :signed_in_user, except: :disable_tracking
  layout 'registration'
  # layout 'none', only: [:site_maintenance, :landing]

  def index
    if signed_in?
      if current_pod
        redirect_to events_path(current_pod.slug)
      else
        redirect_to no_pod_path
      end
    end

    if params['data.json']
      hash = JSON.parse params['data.json']
      user = Unbounce.where(email: hash['email']).last
      user.update_attributes(page_name: params[:page_name], page_url: params[:page_url], ip_address: hash['ip_address'])
    end
  end

  def disable_tracking
    cookies.permanent[:skip_tracking] = 'true'
    flash[:success] = 'Tracking has been disabled. It will not be re-enabled until you clear your browsers cookies.'
    redirect_to pod_path(current_pod)
  end

  def site_maintenance
    render 'public/site_maintenance'
  end

  def no_script
    render :layout => 'none'
  end

  def get_started
    render layout: 'decline'
  end

  def how_does_podanize_work_mobile
    render :layout => false
  end

end
