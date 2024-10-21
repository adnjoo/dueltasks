# config/initializers/stripe.rb

# Stripe.api_key = ENV["API_KEY"]

# TODO: investigate why not working in railway
Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)

# Debugging output to check if the key is being set
# puts "Stripe API key: #{Stripe.api_key}"
