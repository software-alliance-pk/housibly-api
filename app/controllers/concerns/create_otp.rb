module CreateOtp
  include ActiveSupport::Concern

  def otp(user)
    user.generate_password_token! #generate pass token
    # SEND EMAIL/PHONE HERE
    render json: { "otp": user.reset_password_token }, status: :ok
  end
  def forgot_password_otp(user)
    user.generate_signup_token!
    UserVerificationMailer.with(user: user, subject: "OTP Verification").send_otp_to_email.deliver_now
    render json: { "otp": user.reset_signup_token }, status: :ok
  end

  def signup_otp(user)
    user.generate_signup_token!
    UserVerificationMailer.with(user: user, subject: "OTP Verification").send_signup_otp.deliver_now
    render json: { "otp": user.reset_signup_token }, status: :ok
  end

  def resend_new_otp(user)
    user.generate_signup_token!
    UserVerificationMailer.with(user: user, subject: "OTP Verification").resend_new_otp.deliver_now
    render json: { "otp": user.reset_signup_token }, status: :ok
  end

end