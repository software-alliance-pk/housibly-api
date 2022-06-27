class Api::V1::SessionsController < ApiController
  skip_before_action :authenticate_user, only: [:create]
  def create
    @user = User.find_by(email: params[:email])
    if @user & @user.authenticate(params[:password])
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
end
