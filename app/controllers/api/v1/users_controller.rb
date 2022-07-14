class Api::V1::UsersController < Api::V1::ApiController
  def get_profile
    @current_user
  end

  def update_profile
    if @current_user.present?
      @current_user.assign_attributes(user_params)
      if @current_user.save(validate: false)
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
