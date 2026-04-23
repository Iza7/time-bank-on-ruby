class Api::V1::BaseController < ActionController::API
  before_action :authenticate_request!

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Resource not found." }, status: :not_found
  end

  private

  def current_api_user
    @current_api_user
  end

  def authenticate_request!
    token = extract_token
    return unauthorized! if token.nil?

    payload = JsonWebToken.decode(token)
    @current_api_user = User.find_by(id: payload[:user_id])
    unauthorized! unless @current_api_user
  rescue JWT::ExpiredSignature
    render json: { error: "Token has expired." }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { error: "Invalid token." }, status: :unauthorized
  end

  def extract_token
    header = request.headers["Authorization"]
    header&.start_with?("Bearer ") ? header.split(" ").last : nil
  end

  def unauthorized!
    render json: { error: "Unauthorized." }, status: :unauthorized
  end
end
