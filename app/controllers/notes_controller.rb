class NotesController < ApplicationController
  before_filter :can_view?, only: [:index, :new, :show]

  def index
    @notes = current_pod.notes.includes(:user).order('sort_by_date DESC')
  end

  def new
    @note = Note.new(pod_id: current_pod.id)
  end

  def create
    @note = Note.new(params[:note])
    @topic_count = nil
    @body_count = nil
    if @note.save
      flash[:success] = 'Note was created successfully!'
      @note.update_sort_by_date
      # @new_note = current_user.notes.new(pod_id: current_pod.id)
      redirect_to notes_path
    else
      @topic_count = params[:note][:topic_count]
      @body_count  = params[:note][:body_count]
      flash[:error] = @note.errors.full_messages.first
      render :new
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def show
    @notes = current_pod.notes.order('sort_by_date DESC')
    @note = Note.includes(:comments).find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      @note.update_sort_by_date
      @notes = current_pod.notes.order('sort_by_date DESC')
      flash[:success] = 'Your note was updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    flash[:success] = 'Discussion was deleted successfully'
    redirect_to notes_path
  end

  def sort
    if params[:column] == 'topic'
      @notes = current_pod.notes.includes(:event, :user).order("LOWER(topic) #{params[:direction] == 'desc' ? 'asc' : 'desc'}")
    elsif params[:column] == 'is_urgent'
      @notes = current_pod.notes.includes(:event, :user).order("is_urgent #{params[:direction]}").order("sort_by_date #{params[:direction]}")
    else
      @notes = current_pod.notes.includes(:event, :user).order("#{params[:column]} #{params[:direction]}")
    end
  end

  def sort_by_event
    @notes_with_event = current_pod.notes.where('event_id IS NOT NULL').joins(:event).order("lower(events.name) #{'desc' unless params[:direction] == 'desc'}").order("sort_by_date #{params[:direction]}")
    @notes_without_event = current_pod.notes.where('event_id IS NULL').order("sort_by_date #{params[:direction]}")

    if params[:direction] == 'asc'
      @notes = @notes_without_event + @notes_with_event
    else
      @notes = @notes_with_event + @notes_without_event
    end

    render :sort
  end

  def update_last_visit
    current_user.update_last_visit(current_pod, :last_visit_notes)
    render nothing: true, status: 200
  end

  private

  def can_update?
    pod = Pod.find(params[:id])
    render_404 unless current_user.pods.include?(pod)
  end

  def can_view?
    render_404 unless current_user.pods.include?(current_pod)
  end

end
