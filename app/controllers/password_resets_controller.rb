class PasswordResetsController < ApplicationController
  skip_before_filter :signed_in_user

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user.nil?
      flash[:error] = 'Could not find that email address in our system'
    else
      user.send_password_reset
      flash[:notice] = 'An email has been sent with password reset instructions.'
    end
    redirect_to :back
  end

  def edit_from_email
    @user = User.find_by_password_reset_token(params[:id])
    user_not_found and return if @user.nil?
    store_location root_path
    render :edit
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    user_not_found and return if @user.nil?
    @user.testing_password = true
    @user.testing_first_last_name = false
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:error] = 'Password reset has expired.'
      redirect_to new_password_reset_path
    elsif @user.update_attributes(params[:user])
      flash[:success] = 'Password has been reset!'
      redirect_to login_path
    else
      flash[:error] = @user.errors.full_messages.first
      render :edit
    end
  end

  def edit
    @user = current_user
    @user.update_attribute :password_reset_token, SecureRandom.urlsafe_base64
    @user.update_attribute :password_reset_sent_at, Time.zone.now
    store_location
  end

  private

  def user_not_found
    flash[:error] = 'Your authorization code is no longer valid. Please try again.'
    redirect_to root_path
  end

end
