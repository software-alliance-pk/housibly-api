class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:create, :verify_otp, :resend_otp]
  include CreateOtp

  def create
    @user = User.new(user_params)
    if @user.save
      signup_otp(@user)
    else
      render_error_messages(@user)
    end
  end

  def update_personal_info
    if @current_user.is_otp_verified
      @current_user.update(user_params.merge(is_confirmed: true))
    else
      render json: { message: "OTP not verified" }, status: 401
    end
  end

  def verify_otp
    @user = User.find_by(email: user_params[:email], reset_signup_token: params[:otp]) if user_params[:email].present?
    @user = User.find_by(phone_number: user_params[:phone_number], reset_signup_token: params[:otp]) if user_params[:phone_number].present?
    if @user && @user.signup_token_valid?
      @user.update(is_otp_verified: true)
      @token = JsonWebTokenService.encode({ email: @user.email })
    else
      render json: { message: "Incorrect Email or OTP" }, status: 401
    end
  end

  def resend_otp
    twilio_sender_number = Rails.application.credentials.twilio[:sender_number] if Rails.env.development?
    twilio_sender_number = ENV["TWILIO_SENDER_NUMBER"] if Rails.env.production?
    @user = User.find_by(email: user_params[:email]) if user_params[:email].present?
    @user = User.find_by(phone_number: user_params[:phone_number]) if user_params[:phone_number].present?
    if @user
      if user_params[:email].present?
        signup_otp(@user)
      else
        @user.generate_signup_token!
        TwilioService.send_message(
          @user.phone_number,
          twilio_sender_number,
          @user.reset_signup_token
        )
        render json: { "otp": @user.reset_signup_token }, status: :ok
      end
    else
      render json: { message: "Email/Phone not found" }, status: 401
    end
  end

  private

  def user_params
    params.require(:user).
      permit(:full_name, :email, :password, :phone_number, :description, :licensed_realtor,
             :contacted_by_real_estate, :user_type, :profile_type, :otp, :avatar)
  end
end
