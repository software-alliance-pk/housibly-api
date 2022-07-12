module CreateOtp
  include ActiveSupport::Concern

  def otp(user)
    user.generate_password_token! #generate pass token
    # SEND EMAIL/PHONE HERE
    render json: { "otp": user.reset_password_token }, status: :ok
  end

  def signup_otp(user)
    user.generate_signup_token!
    render json: { "otp": user.reset_signup_token }, status: :ok
  end

end