class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service,      only: %i[show edit update destroy]
  before_action :authorize_owner!, only: %i[edit update destroy]

  def index
    @services = Service.includes(:user).order(created_at: :desc)
    @services = @services.where("title LIKE ? OR description LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
  end

  def show
    @already_requested = ServiceRequest
      .where(service: @service, requester: current_user)
      .where(status: %w[pending accepted])
      .exists?
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    @service.user = current_user

    if @service.save
      redirect_to @service, notice: "Service created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: "Service updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    redirect_to services_path, notice: "Service deleted."
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def authorize_owner!
    redirect_to services_path, alert: "Not authorized." unless @service.user == current_user || current_user.role == "admin"
  end

  def service_params
    params.expect(service: [ :title, :description, :duration ])
  end
end
