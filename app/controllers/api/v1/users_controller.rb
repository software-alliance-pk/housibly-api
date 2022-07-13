class Api::V1::UsersController < Api::V1::ApiController
  def get_profile
    @current_user
  end

  def update_profile
    if @current_user.valid?
      if @current_user.update(user_params)
        @current_user
      else
        render_error_messages(@current_user)
      end
    else
      render_error_messages(@current_user)
    end
  end

  private

  def user_params
    params.require(:user).
      permit(:email, :phone_number, :description, :avatar)
  end
end