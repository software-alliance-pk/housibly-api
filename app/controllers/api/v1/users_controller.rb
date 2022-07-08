class Api::V1::UsersController < Api::V1::ApiController
  def get_profile
    @current_user
  end

  def update_profile
    @current_user.update!(user_params)
  end

  private

  def user_params
    params.require(:user).
      permit(:email, :phone_number, :description, :avatar)
  end
end