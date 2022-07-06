class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:create]
  include CreateOtp

  def create
    debugger
    @user = User.new(user_params)
    if @user.save
      signup_otp(@user)
    else
      render_error_messages(@user)
    end
  end

  private
  def user_params
    params.require(:user).
      permit(:full_name, :email, :password, :phone_number, :description, :licensed_realtor,
             :contacted_by_real_estate, :user_type, :profile_type, :avatar)
  end
end
