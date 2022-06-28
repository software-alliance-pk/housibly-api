class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { success: "confirmation email is sent" }, status: :ok
    else
      render json: { error: @user.errors.messages }, status: :ok
    end
  end

  private
  def user_params
    params.require(:user).
      permit(:full_name,:password_confirmation,:email,:password,:phone_number,
             :description,:licensed_realtor,:contacted_by_real_estate,:user_type,:profile_type,:avatar)
  end
end
