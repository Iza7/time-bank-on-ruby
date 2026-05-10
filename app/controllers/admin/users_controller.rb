class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show toggle_active]

  def index
    @users = User.order(:created_at)
  end

  def show
  end

  def toggle_active
    @user.update!(active: !@user.active)
    redirect_to admin_users_path,
                notice: "User #{@user.active ? 'activated' : 'deactivated'}"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
