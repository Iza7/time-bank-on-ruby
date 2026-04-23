class Api::V1::ServicesController < Api::V1::BaseController
  before_action :set_service,      only: %i[show update destroy]
  before_action :authorize_owner!, only: %i[update destroy]

  def index
    services = Service.includes(:user).order(created_at: :desc)
    services = services.where("title LIKE ? OR description LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    render json: services.map { |s| serialize(s) }
  end

  def show
    render json: serialize(@service)
  end

  def create
    service = Service.new(service_params)
    service.user = current_api_user

    if service.save
      render json: serialize(service), status: :created
    else
      render json: { errors: service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      render json: serialize(@service)
    else
      render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    head :no_content
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def authorize_owner!
    render json: { error: "Not authorized." }, status: :forbidden unless @service.user == current_api_user
  end

  def service_params
    params.require(:service).permit(:title, :description, :duration)
  end

  def serialize(service)
    {
      id: service.id, title: service.title, description: service.description,
      duration: service.duration,
      provider: { id: service.user.id, name: service.user.name },
      created_at: service.created_at
    }
  end
end
