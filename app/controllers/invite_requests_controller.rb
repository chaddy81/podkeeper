class InviteRequestsController < ApplicationController
  skip_before_filter :signed_in_user

  def create
    @invite_request = InviteRequest.new(params[:invite_request])
    if @invite_request.save
      flash[:success] = 'Thank you for your interest. We will email you when we\'re ready for you!'
      InviteMailer.delay.invite_request(@invite_request)
      redirect_to root_path
    else
      render 'sessions/new'
    end
  end

end
