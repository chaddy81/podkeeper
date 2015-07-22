class RegistrationsController < ApplicationController
  skip_before_filter :signed_in_user

  layout 'registration'

  def new
    if signed_in?
      flash.keep
      if current_user.pods.any?
        last_pod_visited = Pod.find(current_user.last_pod_visited_id)
        if last_pod_visited.nil?
          redirect_to events_path(current_user.pods.order('created_at').first)
        else
          redirect_to events_path(last_pod_visited)
        end
      elsif current_user.received_invites.unaccepted.where('pod_id IS NOT NULL')
        redirect_to invites_path
      else
        redirect_to new_pod_path
      end
    elsif params[:lp]
      user = Unbounce.find_by_token(params[:lp])
      @pod_user = PodUser.new
      @pod_user.first_name = user.first_name
      @pod_user.last_name = user.last_name
      @pod_user.email = user.email
    else
      @pod_user = PodUser.new
    end
  end

end
