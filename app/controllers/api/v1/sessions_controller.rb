class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:login_with_email, :login_with_phone]

  def login_with_email
    @user = User.find_by(email: user_params[:email], reset_signup_token: params[:otp])
    if @user && @user.authenticate(user_params[:password]) && @user.signup_token_valid?
      if @user
        token = JsonWebTokenService.encode({ email: @user.email })
        render json: { auth_token: token }
      else
        render json: { error: "please verify email address" }, status: :unauthorized
      end
    else
      render json: { error: "Incorrect email or password" }, status: :unauthorized
    end
  end

  def login_with_phone
    @user = User.find_by(phone_number: user_params[:phone_number], reset_signup_token: params[:otp])
    if @user && @user.authenticate(user_params[:password]) && @user.signup_token_valid?
      if @user
        token = JsonWebTokenService.encode({ phone_number: @user.phone_number })
        render json: { auth_token: token }
      else
        render json: { error: "please verify your phone number" }, status: :unauthorized
      end
    else
      render json: { error: "Incorrect phone or password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :phone_number)
  end
end
