class Api::V1::ServiceRequestsController < Api::V1::BaseController
  before_action :set_service_request, only: %i[show accept reject cancel complete]

  def index
    incoming = ServiceRequest.joins(:service)
                             .where(services: { user_id: current_api_user.id })
                             .includes(:service, :requester)

    outgoing = current_api_user.service_requests.includes(:service)

    render json: {
      incoming: incoming.map { |r| serialize(r) },
      outgoing: outgoing.map { |r| serialize(r) }
    }
  end

  def show
    render json: serialize(@service_request)
  end

  def create
    service = Service.find(params[:service_id])
    sr = ServiceRequest.new(service: service, requester: current_api_user)

    if sr.save
      render json: serialize(sr), status: :created
    else
      render json: { errors: sr.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def accept
    return forbidden! unless current_api_user == @service_request.provider
    return bad_transition! unless @service_request.pending?

    @service_request.update!(status: "accepted")
    render json: serialize(@service_request)
  end

  def reject
    return forbidden! unless current_api_user == @service_request.provider
    return bad_transition! unless @service_request.pending?

    @service_request.update!(status: "rejected")
    render json: serialize(@service_request)
  end

  def cancel
    is_participant = current_api_user == @service_request.provider || current_api_user == @service_request.requester
    return forbidden! unless is_participant
    return bad_transition! unless @service_request.pending? || @service_request.accepted?

    @service_request.update!(status: "cancelled")
    render json: serialize(@service_request)
  end

  def complete
    return forbidden! unless current_api_user == @service_request.provider
    return bad_transition! unless @service_request.accepted?

    if CreditTransfer.call(@service_request)
      @service_request.update!(status: "completed")
      render json: serialize(@service_request)
    else
      render json: { error: "Credit transfer failed — requester has insufficient balance." }, status: :unprocessable_entity
    end
  end

  private

  def set_service_request
    @service_request = ServiceRequest.includes(:service, :requester).find(params[:id])
  end

  def forbidden!
    render json: { error: "Not authorized." }, status: :forbidden
  end

  def bad_transition!
    render json: { error: "Action not available for current status." }, status: :unprocessable_entity
  end

  def serialize(sr)
    {
      id: sr.id, status: sr.status,
      service: { id: sr.service.id, title: sr.service.title, duration: sr.service.duration },
      requester: { id: sr.requester.id, name: sr.requester.name },
      provider: { id: sr.provider.id, name: sr.provider.name },
      created_at: sr.created_at
    }
  end
end
