class PodMembershipsController < ApplicationController
  before_filter :is_pod_admin?, only: :index
  before_filter :pod_admin_with_sharing?, only: [:edit, :update]
  before_filter :is_pod_admin_or_self?, only: :destroy

  def index
    pod = current_pod
    render_404 and return if pod.nil?
    @pod_memberships = pod.pod_memberships
    @invites = pod.invites.unaccepted
  end

  def edit
    @pod_membership = PodMembership.find(params[:id])
    @pod_memberships = @pod_membership.pod.pod_memberships
    @invites = @pod_membership.pod.invites.unaccepted
    render :index
  end

  def update
    @pod_membership = PodMembership.find(params[:id])
    if @pod_membership.user == current_user
      access_level = AccessLevel.find(params[:pod_membership][:access_level_id])
      if access_level.id < pod_admin_with_sharing.id && current_pod.pod_memberships.where(access_level_id: pod_admin_with_sharing.id).count <= 1
        flash.now[:warning] = 'You must transfer admin rights with sharing to someone else before demoting yourself'
        @pod_memberships = @pod_membership.pod.pod_memberships
        @invites = @pod_membership.pod.invites.unaccepted
        render :index and return
      end
    end

    old_access_level = @pod_membership.access_level

    @pod_membership.update_attributes(params[:pod_membership])
    flash[:success] = 'Access level was updated successfully.'

    unless old_access_level == @pod_membership.access_level
      PodMailer.delay.access_level_changed(old_access_level, @pod_membership.access_level, @pod_membership)
    end

    if is_at_least_pod_admin?
      redirect_to pod_memberships_path(pod_id: @pod_membership.pod_id)
    else
      redirect_to members_path
    end
  end

  def destroy
    if @pod_membership.pod.users.count == 1
      flash[:warning] = "You are the only member of this Pod. You can #{view_context.link_to 'Invite Others', invite_pods_path(@pod_membership.pod.id)} and then leave, or you can #{view_context.link_to 'Delete this Pod', pod_path(@pod_membership.pod), method: :delete, data: { confirm: 'Are you sure you want to delete this pod? All associated information will also be deleted, including events, invites, and discussions.' }}"
      respond_to do |format|
        format.html { redirect_to :back and return }
        format.js { render 'shared/flash_messages' and return }
      end
    end

    # pop a modal to make them specify new pod organizer if they're removing themselves
    if current_user?(@pod_membership.pod.organizer) && current_user?(@pod_membership.user) && @pod_membership.pod.pod_memberships.where("id != ?", AccessLevel.member.id).count <= 1
      @members = @pod_membership.pod.users.reject { |u| current_user? u }
      render :destroy and return
    end

    # ensure they've transferred admin rights if only top admin is trying to remove themselves
    if current_user?(@pod_membership.user) && @pod_membership.pod_admin_with_sharing? && @pod_membership.pod.pod_memberships.where(access_level_id: AccessLevel.pod_admin_with_sharing.id).count <= 1
      flash[:warning] = "Before leaving this Pod, you must assign at least one person with Pod Admin with Sharing rights. #{view_context.link_to 'Manage Permissions', pod_memberships_path(pod_id: @pod_membership.pod_id)}"
      # redirect_to pods_user_path(current_user) and return
      redirect_to settings_path(anchor: 'leave-a-pod') and return
    end

    @pod_membership.prep_for_destroy!
    @pod_membership.update_attributes(deleted_at: DateTime.now)
    if current_user? @pod_membership.user
      session[:pod_id] = nil if @pod_membership.pod == current_pod
      @pod_membership.reassign_comments(@pod_membership.user)
      flash[:success] = 'You have removed yourself from the Pod successfully'
      PodMailer.you_removed_yourself_from_pod(@pod_membership).deliver
    else
      flash[:success] = 'Pod Member has been removed successfully'
      PodMailer.you_were_removed_from_pod(@pod_membership, current_user).deliver
    end
    set_current_pod(current_user.pods.last)
    @pod_membership.destroy

    redirect_to :back
  end

  def reassign_organizer
    @pod_membership = PodMembership.find(params[:id])
    @pod_membership.pod.update_attribute(:organizer_id, params[:new_pod_organizer_id])
    @pod_membership.pod.pod_memberships.where(user_id: params[:new_pod_organizer_id]).last.update_attribute(:access_level_id, AccessLevel.pod_admin_with_sharing.id)

    @pod_membership.prep_for_destroy!
    PodMailer.delay.new_pod_organizer(@pod_membership.pod, @pod_membership.user.full_name)
    @pod_membership.destroy

    session[:pod_id] = nil if @pod_membership.pod == current_pod
    flash[:success] = 'You have removed yourself from the Pod successfully'
    PodMailer.delay.you_removed_yourself_from_pod(@pod_membership)

    redirect_to pods_user_path(current_user)
  end

  private

  def is_pod_admin?
    render_404 and return unless is_at_least_pod_admin?
  end

  def pod_admin_with_sharing?
    render_404 and return unless is_pod_admin_with_sharing?
  end

  def is_pod_admin_or_self?
    @pod_membership = PodMembership.find(params[:id])
    render_404 and return unless is_at_least_pod_admin? || current_user?(@pod_membership.user)
  end

end
