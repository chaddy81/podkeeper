class InvalidEmailsController < ApplicationController
  before_filter :correct_user

  def destroy
    @invalid_email.destroy
    flash[:success] = 'Invalid Email was deleted successfully!'
    redirect_to :back
  end

  private

  def correct_user
    @invalid_email = InvalidEmail.find(params[:id])
    render_404 and return unless current_user? @invalid_email.user
  end

end