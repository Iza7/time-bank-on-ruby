class ServicesController < ApplicationController
  def index
    @services = Service.all
  end

  def new
  end

  def create
    service = Service.new(service_params)
    service.user_id = session[:user_id]

    if service.save
      redirect_to "/services"
    else
      render :new
    end
  end

  private

  def service_params
    params.permit(:title, :description)
  end
end