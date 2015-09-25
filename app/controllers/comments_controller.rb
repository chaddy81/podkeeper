class CommentsController < ApplicationController
  before_filter :correct_user, except: :create

  def create
    @comment = current_user.comments.new(params[:comment])
    if @comment.save
      flash[:success] = 'Comment was created successfully!'
      @comments = @comment.note.comments.includes(:user)
      @note = @comment.note
      @notes = @note.pod.notes.order('sort_by_date DESC')
      redirect_to note_path(@note)
    else
      flash[:error] = @comment.errors.full_messages.first
      redirect_to :back
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @note = @comment.note
  end

  def update
    if @comment.update_attributes(params[:comment])
      @comments = @comment.note.comments.includes(:user)
      @notes = current_pod.notes.order('sort_by_date DESC')
      flash[:success] = 'Comment was updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    note_id = @comment.note.id
    @comment.destroy
    flash[:success] = 'Comment was deleted successfully'
    redirect_to note_path(note_id)
  end


  private

  def correct_user
    @comment = Comment.find(params[:id])
    render_404 unless current_user?(@comment.user) || is_at_least_pod_admin?
  end

end
