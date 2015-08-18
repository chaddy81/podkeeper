class RsvpsController < ApplicationController
  before_filter :correct_user, only: :update

  def create
    @rsvp = current_user.rsvps.new(rsvp_params)
    if @rsvp.save
      flash[:success] = 'You have RSVP\'d successfully!'
      render :update
    else
      render :form
    end
  end

  def update
    if rsvp.update(rsvp_params)
      flash[:success] = 'RSVP has been updated successfully!'
    else
      render :form
    end
  end

  private

  def rsvp
    @rsvp ||= Rsvp.find(params[:id])
  end

  def correct_user
    @rsvp = Rsvp.find(params[:id])
    render_404 unless current_user.rsvps.include?(@rsvp)
  end

  def rsvp_params
    params.require(:rsvp).permit(:event_id, :rsvp_option_id,
                                 :number_of_adults, :number_of_kids, :comments)
  end
end
