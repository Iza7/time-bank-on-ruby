class ServiceRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service_request, only: %i[show accept reject cancel complete]

  def index
    @incoming = ServiceRequest.joins(:service)
                              .where(services: { user_id: current_user.id })
                              .includes(:service, :requester)
                              .order(created_at: :desc)

    @outgoing = current_user.service_requests
                            .includes(:service)
                            .order(created_at: :desc)
  end

  def show
  end

  def create
    service = Service.find_by(id: params[:service_id])
    return redirect_to services_path, alert: "Service not found." unless service

    @service_request = ServiceRequest.new(service: service, requester: current_user)

    if @service_request.save
      redirect_to @service_request, notice: "Service requested successfully."
    else
      redirect_to service, alert: @service_request.errors.full_messages.to_sentence
    end
  end

  def accept
    return unauthorized! unless current_user == @service_request.provider
    return transition_error! unless @service_request.pending?

    @service_request.update!(status: "accepted")
    redirect_to @service_request, notice: "Request accepted."
  end

  def reject
    return unauthorized! unless current_user == @service_request.provider
    return transition_error! unless @service_request.pending?

    @service_request.update!(status: "rejected")
    redirect_to @service_request, notice: "Request rejected."
  end

  def cancel
    is_participant = current_user == @service_request.provider || current_user == @service_request.requester
    return unauthorized! unless is_participant
    return transition_error! unless @service_request.pending? || @service_request.accepted?

    @service_request.update!(status: "cancelled")
    redirect_to service_requests_path, notice: "Request cancelled."
  end

  def complete
    return unauthorized! unless current_user == @service_request.provider
    return transition_error! unless @service_request.accepted?

    if CreditTransfer.call(@service_request)
      @service_request.update!(status: "completed")
      redirect_to @service_request, notice: "Service completed. Credits transferred."
    else
      redirect_to @service_request, alert: "Credit transfer failed — requester has insufficient balance."
    end
  end

  private

  def set_service_request
    @service_request = ServiceRequest.includes(:service, :requester).find(params[:id])
  end

  def unauthorized!
    redirect_to service_requests_path, alert: "Not authorized."
  end

  def transition_error!
    redirect_to @service_request, alert: "That action is not available for this request."
  end
end
