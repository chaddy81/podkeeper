class SiteCommentsController < ApplicationController
  skip_before_filter :signed_in_user

  def new
    @site_comment = SiteComment.new
    if signed_in?
      @site_comments = current_user.site_comments
    else
      @site_comments = []
    end

    respond_to do |format|
      format.js
      format.html { render_404 }
    end
  end

  def create
    if signed_in?
      @site_comments = current_user.site_comments.dup
      @site_comment = current_user.site_comments.new(params[:site_comment])
    else
      @site_comments = []
      @site_comment = SiteComment.new(params[:site_comment])
    end
    if @site_comment.save
      @site_comments = current_user.site_comments if signed_in?
      flash.now[:success] = 'Thank you for your comments!'
      @new_site_comment = SiteComment.new
    else
      render :new
    end
  end

end
