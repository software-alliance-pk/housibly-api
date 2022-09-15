class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:login]

  def login
    @user = User.find_by(email: user_params[:email])
    if @user&.authenticate(user_params[:password])
      if @user.present?
        @token = JsonWebTokenService.encode({ email: @user.email })
      else
        render json: { message: "please verify email address" }, status: :unauthorized
      end
    else
      render json: { message: "Incorrect email or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
