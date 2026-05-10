class Api::V1::ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    service_request = ServiceRequest.find(params[:service_request_id])

    review = Review.new(
      service_request: service_request,
      reviewer: current_user,
      rating: params[:rating],
      body: params[:body]
    )

    if review.save
      render json: {
        message: 'Review created successfully',
        review: {
          id: review.id,
          rating: review.rating,
          body: review.body
        }
      }, status: :created
    else
      render json: { errors: review.errors.full_messages },
             status: :unprocessable_entity
    end
  end
end