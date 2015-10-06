if Rails.env.production?
  Delayed::Worker.delay_jobs = true
  Delayed::Worker.max_attempts = 3
else
  Delayed::Worker.delay_jobs = false
end