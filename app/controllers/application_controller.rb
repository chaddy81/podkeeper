class ApplicationController < ActionController::Base
  # protect_from_forgery
  include SessionsHelper
  include EventsHelper
  include RsvpsHelper
  include AccessLevelsHelper
  include CalendarHelper

  before_filter :signed_in_user, except: :render_404
  before_filter :get_pods
  before_filter :set_time_zone
  before_filter :ensure_domain if Rails.env.production?

  before_filter :authenticate if Rails.env.staging? || Rails.env.testing?

  APP_DOMAIN = 'www.podkeeper.com'

  def ensure_domain
    if request.env['HTTP_HOST'] != APP_DOMAIN
      puts request.fullpath
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}#{request.fullpath}", :status => 301
    end
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "podanize" && password == "P0dan1ze44"
    end
  end

  def render_404
    respond_to do |format|
      format.html { render file: 'public/404', layout: false }
      format.all { redirect_to controller: 'application', action: 'render_404' }
    end
  end


  def adjust_time_zone(time_zone)
    return 'Eastern Time (US & Canada)' if time_zone == 'America/Havana'

    valid_zones = []
    mod_time_zone_options.each do |o|
      valid_zones << o[1]
    end

    unless valid_zones.include? time_zone
      options = {}
      ActiveSupport::TimeZone::MAPPING.each do |key, value|
        offset = DateTime.now.in_time_zone(key).utc_offset
        if options[offset]
          options[offset][1] << key
          options[offset][1] << value
        else
          options[offset] = [key, [key, value]]
        end
      end

      options.each do |o|
        if o[1][1].include? time_zone
          return o[1][0]
        end
      end
    end

    time_zone
  end

  private

  def detect_browser
    case request.user_agent
      when /iPad/i
        request.variant = :tablet
      when /iPhone/i
        request.variant = :phone
      when /Android/i && /mobile/i
        request.variant = :phone
      when /Android/i
        request.variant = :tablet
      when /Windows Phone/i
        request.variant = :phone
      else
        request.variant = :desktop
    end
  end

  helper_method :detect_browser

  def set_time_zone
    Time.zone = current_user.time_zone if signed_in?
  end

  def get_pods
    return unless signed_in?
    @accessible_pods = current_user.pods.order('lower(name)')
    if !current_user.last_pod_visited_id && @accessible_pods.include?(Pod.where(id: current_user.last_pod_visited_id).first)
      set_current_pod(current_user.pod_memberships.first.pod) if current_user.pod_memberships.any?
    else
      set_current_pod(current_user.pods.where(id: current_user.last_pod_visited_id).first)
    end
  end

end
