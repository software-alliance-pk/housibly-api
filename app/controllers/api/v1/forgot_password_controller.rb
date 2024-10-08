class Api::V1::ForgotPasswordController < Api::V1::ApiController
  skip_before_action :authenticate_user
  include CreateOtp

  def forgot_password_through_email
    if user_params[:email].blank?
      return render json: { message: 'email not found' }
    end
    user = User.find_by(email: user_params[:email])
    if user.present?
      forgot_password_otp(user)

      # user.generate_password_token! #generate pass token
      # # SEND EMAIL/PHONE HERE
      # render json: { "otp": user.reset_password_token}, status: :ok
    else
      render json: { message: 'Email address is not found. Please check and try again.' }, status: :not_found
    end
  end

  def forgot_password_through_phone
    if user_params[:phone_number].blank?
      return render json: { message: 'phone number is not found' }
    end
    twilio_sender_number = Rails.application.credentials.twilio[:sender_number] if Rails.env.development?
    twilio_sender_number = ENV["TWILIO_SENDER_NUMBER"] if Rails.env.production?
    user = User.find_by(phone_number: user_params[:phone_number])
    if user.present?
      # signup_otp(user)
      user.generate_signup_token!
      TwilioService.send_message(
        user.phone_number,
        twilio_sender_number,
        user.reset_signup_token
      )
      render json: { "otp": user.reset_signup_token }, status: :ok
    else
      render json: { message: 'Phone number is not found. Please check and try again.' }, status: :not_found
    end
  end

  def reset_password_with_email
    # otp = user_params[:otp].to_s
    # return render json: { message: "OTP is blank" } if user_params[:otp].blank?
    return render json: { message: "Email is blank" } if user_params[:email].blank?
    # user = User.find_by(reset_password_token: otp)
    user = User.find_by(email: user_params[:email])
    # if user.present? && user.password_token_valid?
    if user.present?
      if user.reset_password!(user_params[:password])
        render json: { status: 'password changed successfully' }, status: :ok
      else
        render json: { message: user.messages.full_message }, status: :unprocessable_entity
      end
    else
      render json: { message: "Email not found" }, status: :not_found
    end
  end

  def reset_password_with_phone
    return render json: { message: "Phone is blank" } if user_params[:phone_number].blank?
    user = User.find_by(phone_number: user_params[:phone_number])
    if user.present?
      if user.reset_password!(user_params[:password])
        render json: { status: 'password changed successfully' }, status: :ok
      else
        render json: { message: user.messages.full_message }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Phone not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :phone_number)
  end
end
