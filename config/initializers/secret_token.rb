# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

secret_token = ENV['QKS1_SECRET_TOKEN']
if secret_token.nil? || secret_token.length < 128
  raise "Secret token cannot be loaded"
else
  Qks1::Application.config.secret_token = secret_token
end
