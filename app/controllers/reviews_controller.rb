class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    service_request = ServiceRequest.find(params[:service_request_id])

    unless current_user == service_request.requester
      return redirect_to service_request, alert: "Only the requester can leave a review."
    end

    unless service_request.completed?
      return redirect_to service_request, alert: "You can only review completed services."
    end

    if service_request.review.present?
      return redirect_to service_request, alert: "You have already reviewed this service."
    end

    review = Review.new(
      service_request: service_request,
      reviewer: current_user,
      rating: params[:rating],
      body: params[:body]
    )

    if review.save
      redirect_to service_request, notice: "Review submitted successfully!"
    else
      redirect_to service_request, alert: review.errors.full_messages.to_sentence
    end
  end
end
