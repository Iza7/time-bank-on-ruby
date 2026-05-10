class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    credits = params[:credits].to_i

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: { name: "#{credits} Time Credits — Time Bank" },
          unit_amount: credits * 100
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: "#{request.base_url}/buy-credits?success=true",
      cancel_url:  "#{request.base_url}/buy-credits?cancelled=true"
    )

    Payment.create!(
      user: current_user,
      stripe_session_id: session.id,
      credits_purchased: credits,
      status: 'pending'
    )

    redirect_to session.url, allow_other_host: true, status: :see_other
  end
end