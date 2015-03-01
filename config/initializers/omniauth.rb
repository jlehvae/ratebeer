Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['RATEBEER_GITHUB_KEY'], ENV['RATEBEER_GITHUB_SECRET']
end