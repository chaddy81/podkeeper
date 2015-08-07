class UnbounceController < ApplicationController
  skip_before_filter :signed_in_user

  def create
    email = params[:email]
    page_variant = params[:pageVariant]
    page_id = params[:pageId]
    utm_source = params[:utm_source]
    utm_medium = params[:utm_medium]
    utm_content = params[:utm_content]
    utm_campaign = params[:utm_campaign]
    reg_page = params[:reg_page]

    session[:reg_page] = ''

    unbounce = Unbounce.create!(email: email, page_variant: page_variant, page_id: page_id, utm_source: utm_source, utm_medium: utm_medium, utm_content: utm_content, utm_campaign: utm_campaign)

    # if reg_page == '1'
    #   session[:reg_page] = '1'
    #   redirect_to new_registration_path lp: unbounce.token
    # else
    #   redirect_to new_session_path lp: unbounce.token
    # end
  end
end
