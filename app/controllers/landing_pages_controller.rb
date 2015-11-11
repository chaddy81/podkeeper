class LandingPagesController < ApplicationController
  skip_before_filter :signed_in_user
  layout 'landing_pages'

  def basketball_gaw
  end
end
