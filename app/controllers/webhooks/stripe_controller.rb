class Webhooks::StripeController < ActionController::Base
  protect_from_forgery with: :null_session

  def create
    payload = request.body.read
    sig = request.env['HTTP_STRIPE_SIGNATURE']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig, ENV['STRIPE_WEBHOOK_SECRET']
      )
    rescue Stripe::SignatureVerificationError
      render json: { error: 'Invalid signature' }, status: :bad_request
      return
    end

    if event.type == 'checkout.session.completed'
      stripe_session = event.data.object
      payment = Payment.find_by(stripe_session_id: stripe_session.id)

      if payment
        payment.update!(
          status: 'completed',
          stripe_payment_intent_id: stripe_session.payment_intent
        )
        payment.user.increment!(:balance, payment.credits_purchased)
      end
    end

    head :ok
  end
end
