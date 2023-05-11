# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Ecommerce::Application.config.secret_token = '89eecb31c4ad2e228d935c441f250a0b3d41d3960f3e16b0b6192d7711ac626a9ff6ad066bf7e7a1f6ffc2537f03e6cba526f2c196c05accf753b9a267c740e3'
SECRET_KEY = Ecommerce::Application.config.secret_token
