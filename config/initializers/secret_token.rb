# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Tinbull::Application.config.secret_token = ENV['SECRET_TOKEN'] || '31b97c4547d7cee0f6b002a4618be989ab4d74ef5722ba99c0430f219d1c7abe577f45d6e4fe42f01586c41d61dfb0ebfcc5294f4090124bd48f9264fa4eda3d'
