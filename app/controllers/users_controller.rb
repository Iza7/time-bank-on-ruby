class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)
    user.balance = 10
    user.role = "user"

    if user.save
      redirect_to "/login"
    else
      render :new
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end