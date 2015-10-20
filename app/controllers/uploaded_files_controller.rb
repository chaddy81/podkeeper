class UploadedFilesController < ApplicationController
  before_filter :current_pod_exists
  before_filter :has_access, only: [:edit, :update, :destroy]
  before_filter :get_data

  def index
  end

  def new
    @uploaded_file = UploadedFile.new
  end

  def create
    @uploaded_file = UploadedFile.new(params[:uploaded_file])
    @uploaded_file.pod_membership = current_pod_membership

    if @uploaded_file.file.present? && @uploaded_file.file.file.content_type.include?('html') == false && @uploaded_file.save
      flash[:success] = 'File was added sucessfully'
      redirect_to uploaded_files_path
    elsif @uploaded_file.errors.messages.has_key?(:file) || @uploaded_file.errors.messages.has_key?(:base)
      flash[:error] = @uploaded_file.errors.full_messages.first
    else

      @uploaded_file.remove_file!

      if @uploaded_file.remote_file_url.present? && %w(ftp sft htt).include?(@uploaded_file.remote_file_url[0..2]) == false
        params[:uploaded_file][:remote_file_url] = "http://#{@uploaded_file.remote_file_url}"
      end
      @uploaded_file.url = params[:uploaded_file][:remote_file_url]
      @uploaded_file.remote_file_url = params[:uploaded_file][:remote_file_url]

      if @uploaded_file.save
        flash[:success] = 'Link to file was added sucessfully'
        redirect_to uploaded_files_path
      else
        flash.now[:error] = 'There was an error trying to upload the file. Make sure you enter a fully qualified url (ie "http://www.podkeeper.com")'
        render :new
      end
    end
  end

  def edit
    render :index
  end

  def update
    @uploaded_file = UploadedFile.find(params[:id])
    if @uploaded_file.update_attributes(params[:uploaded_file])
      flash[:success] = 'Description was updated successfully'
      redirect_to uploaded_files_path
    else
      render :index
    end
  end

  def destroy
    @uploaded_file = UploadedFile.find(params[:id])
    @uploaded_file.destroy
    flash[:success] = 'File was removed successfully'
    redirect_to uploaded_files_path
  end

  def update_last_visit
    current_user.update_last_visit(current_pod, :last_visit_files)
    render nothing: true, status: 200
  end

  private

  def has_access
    @uploaded_file = UploadedFile.find(params[:id])
    render_404 and return unless current_user?(@uploaded_file.pod_membership.user) || is_at_least_pod_admin?
  end

  def get_data
    if params[:pod_id]
      set_current_pod current_user.pods.where(id: params[:pod_id]).first
    end
    @uploaded_file = UploadedFile.new(pod_membership_id: current_pod_membership.id)
    @uploaded_files = UploadedFile.joins(:pod_membership).where(pod_memberships: { pod_id: current_pod.id }).page(params[:page]).per(20)
    @has_access_to_a_file = false
    @uploaded_files.each do |uploaded_file|
      if current_user == uploaded_file.pod_membership.user
        @has_access_to_a_file = true
        break
      end
    end
  end

end
