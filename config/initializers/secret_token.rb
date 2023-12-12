# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

# Rails will enforce presence and a minimum length of 30 chars.
if (Rails.env.development? || Rails.env.test?)
  Ichigo::Application.config.secret_token = 'XdrXqYbJ6xk1YWTCojCxEn3zzlmETZvo'
else
  # from /etc/login.conf on server
  Ichigo::Application.config.secret_token = ENV["#{Rails.env.upcase}_KEY"]
end
