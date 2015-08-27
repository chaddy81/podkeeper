class ListsController < ApplicationController
  before_filter :user_belongs_to_pod?, only: :show
  before_filter :can_create?, only: :new
  before_filter :is_creator_or_admin?, only: [:edit, :update, :destroy, :notify_pod]
  before_filter :get_pod

  def index
    @lists = @pod.lists.includes(:list_items, :creator, :list_type).page(params[:page]).order('created_at DESC').per(10)
  end

  def show
    @lists = @pod.lists.includes(:list_items).page(params[:page]).per(10)
    @list = List.find params[:id]
    render :index
  end

  def new
    @list = @pod.lists.build
  end

  def create
    @list = List.new(params[:list])
    @list.creator = current_user
    @list.pod = current_pod
    if @list.save
      flash[:success] = 'List has been created successfully'
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  def edit
    @list = List.find params[:id]
  end

  def update
    @list = List.find params[:id]
    if @list.update_attributes(params[:list])
      flash[:success] = 'List has been updated successfully'
      redirect_to list_path(@list)
    else
      render :edit
    end
  end

  def destroy
    @list = List.find params[:id]
    @list.destroy
    flash[:success] = 'List has been deleted'
    redirect_to lists_path
  end

  def notify_pod
    Notifications.new.new_list_notification(@list)
    @list.update_column(:notification_has_been_sent, true)
    flash[:success] = 'Emails have been sent out to all pod members'
    redirect_to lists_path
  end

  def add_list_item
    @list = List.find(params[:id])
  end

  def update_last_visit
    current_user.update_last_visit(current_pod, :last_visit_lists)
    render nothing: true, status: 200
  end

  private

  def can_create?
    pod = Pod.find(current_pod)
    render_404 unless current_user.pods.include?(pod)
  end

  def user_belongs_to_pod?
    @list = List.find(params[:id])
    render_404 unless current_user.pods.include?(@list.pod)
  end

  def is_creator_or_admin?
    @list = List.find(params[:id])
    render_404 unless current_user?(@list.creator) || is_at_least_pod_admin?
  end

  def get_pod
    @pod = current_pod || current_user.pods.where(id: params[:pod_id]).first
  end

end
