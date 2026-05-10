class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'eur',
          product_data: { name: "#{params[:credits]} Time Credits" },
          unit_amount: params[:credits].to_i * 100
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: "#{request.base_url}?payment=success",
      cancel_url: "#{request.base_url}?payment=cancelled"
    )

    Payment.create!(
      user: current_user,
      stripe_session_id: session.id,
      credits_purchased: params[:credits].to_i,
      status: 'pending'
    )

    render json: { checkout_url: session.url }
  end
end       