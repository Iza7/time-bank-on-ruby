class Api::V1::AuthController < ActionController::API
  def register
    user = User.new(register_params)
    user.balance = 10
    user.role = "user"

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: serialize_user(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email].to_s.downcase.strip)

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: serialize_user(user) }
    else
      render json: { error: "Invalid email or password." }, status: :unauthorized
    end
  end

  private

  def register_params
    params.require(:user).permit(:name, :email, :password)
  end

  def serialize_user(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      balance: user.balance,
      role: user.role
    }
  end
end
