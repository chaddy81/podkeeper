class KidsController < ApplicationController
  before_filter :correct_user, only: [:edit, :update, :destroy]

  def new
    @pod = Pod.find(params[:pod_id])
    @kid = Kid.new
  end

  def create
    @kid = Kid.new(params[:kid])
    @pod = @kid.pod
    if @kid.valid?
      kids = @kid.name.split(',')
      kids.each do |kid|
        kid = current_user.kids.create(name: kid.strip, pod: @pod)
      end
      flash[:success] = 'Child created successfully!'
    end
    render :update_member_list
  end

  def edit
  end

  def update
    @pod = @kid.pod
    if @kid.update_attributes(params[:kid])
      flash[:success] = 'Child updated successfully!'
      render :update_member_list
    else
      render :edit
    end
  end

  def destroy
    @kid.destroy
    flash[:success] = "Child was removed successfully!"
    redirect_to :back
  end

  private

  def correct_user
    @kid = Kid.find(params[:id])
    render_404 unless current_user?(@kid.user)
  end

end