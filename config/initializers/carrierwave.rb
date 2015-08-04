CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJKXUNYPSB5AC73LA',
    :aws_secret_access_key  => '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',
  }
  config.fog_directory  = 'podanize-images'
  config.fog_public     = false

  # form re-displays on heroku
  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
