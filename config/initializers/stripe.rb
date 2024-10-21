# config/initializers/stripe.rb

Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

# TODO: investigate why not working in railway
# Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
