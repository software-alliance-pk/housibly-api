class Api::V1::ForgotPasswordController < Api::V1::ApiController
  skip_before_action :authenticate_user
  def forgot_password_through_email
    if user_params[:email].blank?
      return render json: { error: 'email not found' }
    end
    user = User.find_by(email: user_params[:email])
    if user.present?
      user.generate_password_token! #generate pass token
      # SEND EMAIL HERE
      render json: { "otp": user.reset_password_token}, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end
  def reset_password
    otp = user_params[:otp].to_s
    if user_params[:email].blank?
      return render json: { error: "OTP not present" }
    end
    user = User.find_by(reset_password_token: otp)
    if user.present? && user.password_token_valid?
      if user.reset_password!(user_params[:password])
        render json: { status: 'password changed successfully' }, status: :ok
      else
        render json: { error: user.errors.full_message }, status: :unprocessable_entity
      end
    else
      render json: { error: ['Link not valid or expired. Try again'] }, status: :not_found
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password ,:phone_number, :otp)
  end
end
