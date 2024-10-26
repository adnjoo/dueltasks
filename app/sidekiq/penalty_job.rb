# app/jobs/penalty_job.rb
class PenaltyJob
  include Sidekiq::Job

  # Ensure job uniqueness until the job starts executing
  sidekiq_options lock: :until_executed

  def perform(note_id)
    note = Note.find(note_id)
    user = note.user

    # Check if the note is incomplete and the deadline has passed
    if !note.completed && note.deadline < Time.current
      Rails.logger.info "PenaltyJob: Charging user #{user.id} for not completing the task #{note.id}"

      charge_user(user, note)
    end
  end

  private

  def charge_user(user, note)
    amount = 100 # Penalty fee in cents ($1.00)

    # Retrieve the user's default payment method from Stripe
    payment_method_id = Stripe::Customer.retrieve(user.stripe_id).invoice_settings.default_payment_method

    if payment_method_id
      # Create a payment intent to charge the user
      Stripe::PaymentIntent.create({
        amount: amount,
        currency: "usd",
        customer: user.stripe_id,
        payment_method: payment_method_id,
        off_session: true, # Charge without active user session
        confirm: true,
        description: "Penalty for not completing the task: #{note.title}"
      })
    else
      Rails.logger.error "No payment method found for user #{user.id}"
    end
  end
end
