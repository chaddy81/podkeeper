class SettingsController < ApplicationController

  def edit
    @setting = current_user.setting
  end

  def update
  	@setting = Setting.find(params[:id])
    @setting.update_attributes(params[:setting])
    flash[:success] = 'Settings were successfully updated!'
    redirect_to edit_user_path(current_user, active: 'settings')
  end

end
