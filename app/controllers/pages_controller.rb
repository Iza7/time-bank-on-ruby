class PagesController < ApplicationController
  before_action :authenticate_user!

  def profile
  end

  def edit
  end

  def update
    if current_user.update(profile_params)
      redirect_to "/profile", notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    permitted = params.require(:user).permit(:name, :email, :password)
    permitted.delete(:password) if permitted[:password].blank?
    permitted
  end
end
