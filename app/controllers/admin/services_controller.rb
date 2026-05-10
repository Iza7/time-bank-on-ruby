class Admin::ServicesController < Admin::BaseController
  before_action :set_service, only: %i[toggle_visible destroy]

  def index
    @services = Service.all
  end

  def toggle_visible
    @service.update!(visible: !@service.visible)
    redirect_to admin_services_path,
                notice: "Service #{@service.visible ? 'shown' : 'hidden'}"
  end

  def destroy
    @service.destroy
    redirect_to admin_services_path, notice: "Service removed"
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end
end
