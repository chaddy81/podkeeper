class UsersController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new, :create, :create_user_and_pod]
  skip_before_filter :set_time_zone, only: :update_fb_time_zone
  layout 'registration', only: :thank_you

  def new
    invite = Invite.find_by_auth_token(params[:auth_token])
    if invite.nil?
      render_404 and return
    elsif signed_in?
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
  end

  def create
    @user = User.new(params[:user])

    if params[:user][:time_zone] == ''
      @user.time_zone = 'America/New_York'
    end

    @user.testing_password = true
    @user.testing_password_confirmation = false
    @user.time_zone = adjust_time_zone(@user.time_zone)

    if @user.save
      sign_in @user, @user.remember_me
      UserMailer.delay.new_user_welcome(@user)
      flash[:success] = 'Welcome to PodKeeper!'

      unless @user.invite_id.blank?
        # assign invites from original invite email (in case it was changed in signup form)
        invite = Invite.find(@user.invite_id)
        @user.assign_invites(invite.email)

        @user.received_invites.where(pod_id: @user.pod_id).each do |invite|
          invite.accept!
          unless @user.pods.include?(invite.pod) || invite.pod.nil?
            @user.pod_memberships.create(pod: invite.pod, access_level: AccessLevel.member)
          end
          set_current_pod(@user.pod_memberships.last.pod)
        end

        Comment.where(invite_id: invite.id).each do |comment|
          comment.convert_to_user_comment(@user.id)
        end

        redirect_to events_path
      else
        redirect_to new_pod_path
      end


    else
      @pod = Pod.find(@user.pod_id) unless @user.pod_id.nil?
      render 'registrations/new'
    end
  end

  def edit
    @user = current_user
    @settings = @user.settings.page(params[:page]).per(5)
    if params[:pod_id].present?
      @pod = current_user.pods.where(id: params[:pod_id]).first
    else
      @pod_memberships = current_user.pod_memberships.joins(:pod).order('pods.name')
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password] && params[:user][:password_confirmation]
      @user.testing_password = true
    else
      @user.testing_password = false
    end

    if @user.update_attributes(params[:user])
      session[:user_updated] = ''
      flash[:success] = 'Account information updated successfully!'
      redirect_to edit_user_path(@user)
    else
      session[:user_updated] = false
      @settings = @user.settings.all
      @pod_memberships = current_user.pod_memberships.joins(:pod).order('pods.name')
      flash[:error] = @user.errors.full_messages.first
      render :edit
    end
  end

  def pods
    if params[:pod_id].present?
      @pod = current_user.pods.where(id: params[:pod_id]).first
      set_current_pod(@pod)
    else
      @pod_memberships = current_user.pod_memberships.joins(:pod).order('pods.name')
    end

  end

  def update_time_zone
    @time_zone = params[:time_zone]
    current_user.update_attribute(:time_zone, @time_zone)
  end

  def update_fb_time_zone
    @time_zone = params[:time_zone]
    current_user.update_attribute(:time_zone, @time_zone)
    render nothing: true, status: 200
  end

  def seen_splash_message
    user = User.find(params[:user_id])
    user.update_column('has_seen_splash_message', true)
    render nothing: true
  end

  def seen_get_pod_going
    user = User.find(params[:user_id])
    user.update_column(:has_seen_get_pod_going, true)
    render nothing: true
  end

  def thank_you
    @pod = current_user.pods.last
  end
end
