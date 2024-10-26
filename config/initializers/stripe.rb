# config/initializers/stripe.rb

# Set the Stripe API key, preferring the environment variable if available.
# TODO: Investigate why the key might not be loading correctly in Railway.
Stripe.api_key = ENV["STRIPE_SECRET_KEY"] || Rails.application.credentials.dig(:stripe, :secret_key)

# Debugging output to verify if the API key is being set correctly.
# puts "Stripe API key: #{Stripe.api_key}"
