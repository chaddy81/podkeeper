class InvitesController < ApplicationController
  skip_before_filter :signed_in_user, only: [:pod_preview, :decline_pod]

  def index
    invite = Invite.find_by_id(params[:invite_id])
    if invite.present? && current_user?(invite.invitee) == false
      sign_out
      redirect_to invites_path and return
    end

    @visible_invites = current_user.received_invites.unaccepted.where('pod_id IS NOT NULL').includes(:pod, pod: :organizer)
  end

  # ask group leader to create pod (POST)
  def create
    @invite = current_user.sent_invites.new(params[:invite])
    if @invite.save
      flash[:success] = 'Invite has been sent successfully'
      redirect_to new_pod_path(active: 'invites')
      InviteMailer.delay.create_pod_invite(@invite)
    else
      @pod = current_user.pods_as_organizer.new
      render 'pods/new'
    end
  end

  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy
    respond_to do |format|
      format.html do
        flash[:success] = 'Pod invite has been removed successfully'
        redirect_to :back
      end
      format.js
    end
  end

  def decline
    @invite = Invite.find(params[:id])
    @invite.decline!
    flash[:success] = 'Pod Invite has been removed successfully'
    redirect_to invites_path
  end

  def accept
    @invite = Invite.find(params[:id])
    @invite.accept!

    if current_user.pod_memberships.with_deleted.pluck(:pod_id).include?(@invite.pod_id)
      current_user.pod_memberships.with_deleted.where(pod_id: @invite.pod_id).first.restore
    else
      current_user.pod_memberships.create(pod: @invite.pod, access_level: AccessLevel.member)
    end

    @invite.pod.notes.each do |note|
      note.comments.where(invite_id: @invite.id).each do |comment|
        comment.convert_to_user_comment(current_user.id)
      end
    end

    @visible_invites = current_user.received_invites.unaccepted.where('pod_id IS NOT NULL').includes(:pod, pod: :organizer)
    if @visible_invites.any?
      flash[:success] = "You have successfully joined this Pod #{view_context.link_to 'Go to this Pod', events_path(@invite.pod)}"
      redirect_to invites_path
    else
      flash[:success] = 'You have successfully joined this Pod'
      redirect_to events_path(@invite.pod)
    end
    set_current_pod(@invite.pod)
    PodMailer.delay.join_pod_confirmation(@invite.pod, current_user)
  end

  def pod_preview
    @invite = Invite.find(params[:id])
  end

  def decline_pod
    @invite = Invite.find(params[:id])
    declined = params[:declined]
    if declined == "true"
      @invite.destroy
      flash[:success] = 'You have successfully declined this Pod'
      redirect_to root_url
    else
      render layout: 'application'
    end
  end

end
