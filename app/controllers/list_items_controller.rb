class ListItemsController < ApplicationController

  def create
    @list_item = ListItem.new(params[:list_item])
    @list_item.user_id = current_user.id if @list_item.sign_me_up == 'true'
    @row_number = params[:list_item][:row_number]
    unless @list_item.save
      render :render_form
    end
  end

  def edit
    @list_item = ListItem.find(params[:id])
    respond_to :js
  end

  def update
    @list_item = ListItem.find(params[:id])
    params[:list_item][:user_id] = current_user.id if params[:list_item][:sign_me_up] == 'true'
    @row_number = params[:list_item][:row_number]
    unless @list_item.update_attributes(params[:list_item])
      render :render_form
    end
  end

  def destroy
    @list_item = ListItem.find(params[:id])
    @list_item.destroy
  end

end
