class Api::V1::UsersController < Api::V1::BaseController
  def show
    render json: serialize_user(current_api_user)
  end

  def update
    if current_api_user.update(update_params)
      render json: serialize_user(current_api_user)
    else
      render json: { errors: current_api_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def update_params
    params.require(:user).permit(:name, :email, :password)
  end

  def serialize_user(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      balance: user.balance,
      role: user.role,
      created_at: user.created_at
    }
  end
end
