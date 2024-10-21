# app/controllers/webhooks_controller.rb
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    # docs: https://stripe.com/docs/payments/checkout/fulfill-orders
    # receive POST from Stripe
    payload = request.body.read
    signature_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, signature_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      render json: { message: e }, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: { message: e }, status: 400
      return
    end

    # Handle the event
    case event.type
    when "checkout.session.completed"
      # Payment is successful and the subscription is created.
      # Provision the subscription and save the customer ID to your database.
    when "checkout.session.async_payment_succeeded"
      # Some payments take longer to succeed (usually noncredit card payments)
      # You could do logic here to account for that.
    when "invoice.payment_succeeded"
      # Continue to provide the subscription as payments continue to be made.
      # Store the status in your database and check when a user accesses your service.
      # This approach helps you avoid hitting rate limits.
    when "invoice.payment_failed"
      # The payment failed or the customer does not have a valid payment method.
      # The subscription becomes past_due. Notify the customer and send them to the
      # customer portal to update their payment information.
    else
      puts "Unhandled event type: #{event.type}"
    end
  end
end
