class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:create, :verify_otp, :email_resend_otp]
  include CreateOtp

  def create
    @user = User.new(user_params)
    if @user.save
      @user.generate_signup_token!
    else
      render_error_messages(@user)
    end
  end

  def update_personal_info
    if @current_user.is_otp_verified
      @current_user.update!(user_params)
      @current_user.update!(is_confirmed: true)
    else
      render json: { message: "OTP not verified" }, status: 401
    end
  end

  def verify_otp
    @user = User.find_by(email: user_params[:email], reset_signup_token: params[:otp])
    if @user && @user.signup_token_valid?
      @user.update(is_otp_verified: true)
      @token = JsonWebTokenService.encode({ email: @user.email })
    else
      render json: { message: "Incorrect Email or OTP" }, status: 401
    end
  end

  def email_resend_otp
    @user = User.find_by(email: user_params[:email])
    if @user
      signup_otp(@user)
    else
      render_error_messages(@user)
    end
  end

  private

  def user_params
    params.require(:user).
      permit(:full_name, :email, :password, :phone_number, :description, :licensed_realtor,
             :contacted_by_real_estate, :user_type, :profile_type, :otp, :avatar)
  end
end
