class PodsController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new_with_code, :create, :create_user_and_pod, :update_pod_sub_category]
  skip_before_filter :get_pods, only: :no_pod
  skip_before_filter :set_time_zone, only: :no_pod
  before_filter :user_belongs_to_pod?, only: [:show]
  before_filter :is_organizer?, only: [:edit, :update, :destroy]
  before_filter :can_access?, only: :invite

  layout 'registration', only: :create_user_and_pod

  respond_to :html, :js, :json

  def new
    if params[:auth_token]
      invite = Invite.find_by_auth_token(params[:auth_token])
      if invite.present? && current_user?(invite.invitee) == false
        sign_out
        redirect_to new_pod_path and return
      end
    end
    @pod = current_user.pods_as_organizer.new(name: params[:name])
    @invite = current_user.sent_invites.new
    @active = params[:active] || 'pods'
  end

  def new_with_code
    redirect_to root_path and return if signed_in?
    @invite = Invite.find_by_auth_token(params[:pod_id])
    @pod_user = PodUser.new
    if @invite.present?
      @pod_user.first_name = @invite.first_name
      @pod_user.last_name = @invite.last_name
      @pod_user.email = @invite.email
      @pod_user.invite_id = @invite.id
      @pod_user.name = @invite.pod_name
      render :new_with_code
    else
      redirect_to new_session_path
    end
  end

  def create_user_and_pod
    @pod_user = PodUser.new(pod_user_params)

    if params[:pod_user][:time_zone] == ''
      @pod_user.time_zone = 'America/New_York'
    end

    @pod_user.testing_name = false
    @pod_user.testing_pod_category = false
    @pod_user.testing_first_name = false
    @pod_user.testing_last_name = false

    if @pod_user.valid?
      @pod_user.time_zone = adjust_time_zone(@pod_user.time_zone)

      @user = User.create!(email: @pod_user.email,
                           time_zone: @pod_user.time_zone,
                           remember_me: @pod_user.remember_me,
                           password: @pod_user.password)

      sign_in @user, @user.remember_me
      UserMailer.delay.new_user_welcome(@user)
      flash[:success] = 'Welcome to PodKeeper!'
      if params[:pod_user][:pod_id].present?
        pod = Pod.find(params[:pod_user][:pod_id])
        Invite.find_by_id(@pod_user.invite_id).accept!
      else
        pod = Pod.where(id: @user.last_pod_visited_id).first || @user.pods.last
      end
      set_current_pod(pod)
      redirect_to events_path
    else
      @invite = Invite.find_by_id(@pod_user.invite_id)
      if @invite
        flash[:error] = @pod_user.errors.full_messages.first
        session[:error] = "failed"
        render :new_with_code
      else
        flash[:error] = @pod_user.errors.full_messages.first
        # redirect_to new_session_path
        if session[:reg_page] == '1'
          render 'registrations/new'
        else
          render 'sessions/new'
        end
      end
    end
  end

  def create
    @pod = Pod.new(params[:pod])
    @pod.organizer = current_user
    if @pod.save
      @pod.add_organizer
      flash[:success] = 'Congratulations! You have added a new Pod'
      GoogleAnalyticsApi.new.send_event('pod', 'create','success', analytics_client_id)
      set_current_pod(@pod) # Moved from show method as being set after render
      redirect_to invite_pods_path
    else
      @active = 'pods'
      @invite = current_user.sent_invites.new
      flash[:error] = @pod.errors.full_messages.first
      render :new
    end
  end

  def show
    params[:column] = 'updated_at'
    params[:direction] = 'desc'
    @notes = @pod.notes.includes(:user, :event).order('sort_by_date DESC')
    @note = current_user.notes.new(pod_id: current_pod.id)
    @first_visit = true
  end

  def details
    @pod = current_pod
  end

  def edit
    @pod = current_pod
  end

  def set_pod
    pod = Pod.find(params[:pod_id])
    set_current_pod(pod)
    render js: "window.location = '#{events_path}'"
  end

  def update
    @pod.pod_category_id = nil
    @pod.pod_sub_category_id = nil

    if @pod.update_attributes(params[:pod])
      flash[:success] = 'Pod has been updated successfully!'
      redirect_to root_path
    else
      flash[:error] = @pod.errors.full_messages.first
      render :edit
    end

  end

  def destroy
    # send out notification emails
    @pod.users.each do |user|
      PodMailer.delay.pod_deleted(@pod, user, current_user)
    end

    # record key information
    @pod.save_pod_attributes(current_user)

    # delete pod
    @pod.destroy
    session[:pod_id] = nil
    current_user.record_last_pod!(current_user.pods.last.try(:id))
    flash[:success] = 'You have deleted the Pod successfully'
    redirect_to root_path
  end

  def members
    if params[:pod_id].present?
      set_current_pod Pod.where(id: params[:pod_id]).first
    end
    @pod = current_pod
    members = @pod.users
    invited_users = @pod.invites.unaccepted
    invited_users_with_only_first_name = invited_users.where("(last_name IS NULL OR last_name = '') AND (first_name IS NOT NULL AND first_name != '')").order(:first_name)
    invited_users_with_only_last_name = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NOT NULL AND last_name != '')").order(:last_name)
    invited_users_with_only_email = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NULL OR last_name = '')").order(:email)
    invited_users_with_all_info = invited_users - (invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email)
    members.sort_by { |u| [u.last_name.downcase, u.first_name.downcase] }
    @users = members + invited_users_with_all_info + invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email

    declined_invites = @pod.invites.declined
    declined_invites_with_only_first_name = declined_invites.where("(last_name IS NULL OR last_name = '') AND (first_name IS NOT NULL AND first_name != '')").order(:first_name)
    declined_invites_with_only_last_name = declined_invites.where("(first_name IS NULL OR first_name = '') AND (last_name IS NOT NULL AND last_name != '')").order(:last_name)
    declined_invites_with_only_email = declined_invites.where("(first_name IS NULL OR first_name = '') AND (last_name IS NULL OR last_name = '')").order(:email)
    declined_invites_with_all_info = declined_invites - (invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email)
    @declined_invites = declined_invites_with_all_info + declined_invites_with_only_first_name + declined_invites_with_only_last_name + declined_invites_with_only_email
  end

  def invite
    @pod = current_pod
    invited_users = @pod.invites.unaccepted
    invited_users_with_only_first_name = invited_users.where("(last_name IS NULL OR last_name = '') AND (first_name IS NOT NULL AND first_name != '')").order(:first_name)
    invited_users_with_only_last_name = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NOT NULL AND last_name != '')").order(:last_name)
    invited_users_with_only_email = invited_users.where("(first_name IS NULL OR first_name = '') AND (last_name IS NULL OR last_name = '')").order(:email)
    invited_users_with_all_info = invited_users - (invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email)
    @outstanding_invites = invited_users_with_all_info + invited_users_with_only_first_name + invited_users_with_only_last_name + invited_users_with_only_email
    @invite = @pod.invites.new
  end

  def create_invite
    puts "Pods create invite"
    @invite = Invite.new(params[:invite])
    @outstanding_invites = @invite.pod.invites.unaccepted.includes(:reminders)
    if @invite.save
      @new_invite = @invite.pod.invites.new
      flash[:success] = 'Invitation was sent successfully!'
      InviteMailer.delay.pod_invite(@invite)
      redirect_to pod_invite_path(pod_id: current_pod.id)
    else
      render :invite
    end
  end

  def update_pod_sub_category
    pod_category = PodCategory.find(params[:id])
    render json: pod_category.subcategories_in_order.to_json
  end

  def switch
    @pod = Pod.find_by_slug(params[:pod_id])
    set_current_pod(@pod)
    redirect_to @pod
  end

  def no_pod
    session[:view_count] ||= 0
    session[:view_count] += 1
    puts session[:view_count]
  end

  private

  def user_belongs_to_pod?
    @pod = Pod.with_deleted.find_by_slug(params[:id])
    render_404 and return if @pod.nil?

    if current_user.pod_memberships.only_deleted.pluck(:pod_id).include? @pod.id
      set_current_pod(current_user.pods.last)
      render 'public/pod_does_not_exist', layout: 'none'
    elsif current_user.pods.include?(@pod)
      # we're good
    else
      set_current_pod(current_user.pods.last)
      render_404 and return
    end
  end

  def is_organizer?
    @pod = Pod.find_by_slug(params[:id])
    render_404 if @pod.nil? || !is_at_least_pod_admin?
  end

  def can_access?
    pod = current_pod
    render_404 unless current_user.pods.include?(pod)
  end

  def pod_user_params
    params.require(:pod_user).permit(:password, :password_confirmation, :pod_category_id, :pod_category, :pod_sub_category_id, :pod_sub_category,
                  :description, :invites_attributes, :name, :first_name, :last_name, :email, :password, :phone,
                  :remember_me, :time_zone, :invite_id)
  end
end
