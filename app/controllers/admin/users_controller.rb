class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(:created_at)
  end

  def show
    @user = User.find(params[:id])
  end
end
