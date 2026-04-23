class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.balance = 10
    @user.role = "user"

    if @user.save
      redirect_to "/login", notice: "Account created. Please log in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.expect(user: [ :name, :email, :password ])
  end
end
