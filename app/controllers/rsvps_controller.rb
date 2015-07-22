class RsvpsController < ApplicationController
  before_filter :correct_user, only: :update

  def create
    @rsvp = current_user.rsvps.new(params[:rsvp])
    if @rsvp.save
      flash.now[:success] = 'You have RSVP\'d successfully!'
      render :rsvp_updated
    else
      render :form
    end
  end

  def update
    @rsvp = Rsvp.find(params[:id])
    if @rsvp.update_attributes(params[:rsvp])
      flash.now[:success] = 'RSVP was updated successfully!'
      render :rsvp_updated
    else
      render :form
    end
  end

  private

  def correct_user
    @rsvp = Rsvp.find(params[:id])
    render_404 unless current_user.rsvps.include?(@rsvp)
  end

end
