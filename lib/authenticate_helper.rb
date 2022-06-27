module AuthenticateHelper
  def authenticate_user
    email = JsonWebTokenService.decode(request.headers["HTTP_AUTH_TOKEN"])["email"]
    @current_user = User.find_by(email: email)
    render json: { error: "not authorized" }, status: 401 unless @current_user
  end
  def user_sign_in?
    !!current_user
  end
  def current_user
    @current_user
  end
end