class Unbounce < ActiveRecord::Base
  attr_accessible :email, :first_name, :ip_address, :last_name, :page_id, :page_name, :page_url, :page_variant,
    :utm_source, :utm_medium, :utm_content, :utm_campaign

  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
