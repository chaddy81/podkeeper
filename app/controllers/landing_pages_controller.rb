class LandingPagesController < ApplicationController
  skip_before_filter :signed_in_user
  layout 'landing_pages'

  def basketball
  end

  def basketball_gaw
  end

  def basketball_fba
  end
end
