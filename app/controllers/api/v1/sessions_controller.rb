class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:create]
  def create
    @user = User.find_by(email: user_params[:email])
    if @user && @user.authenticate(user_params[:password])
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

  private
  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end
end
