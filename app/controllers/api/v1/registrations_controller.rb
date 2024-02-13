# frozen_string_literal: true

class Api::V1::RegistrationsController < Api::V1::ApiController
  include CreateOtp

  skip_before_action :authenticate_user, only: [:create, :verify_otp, :resend_otp]

  def create
    @user = User.new(user_params)
    if @user.save
      @mobile_device_token = @user.mobile_devices.first if @user.mobile_devices.present?
      signup_otp(@user)
    else
      render_error_messages(@user)
    end
  end

  def add_user_info
    if @current_user.is_otp_verified
      @current_user.update(user_params.merge(is_confirmed: true, login_type: 'manual', profile_complete: true))
      @current_user.user_setting.destroy if @current_user.user_setting.present?
      @current_user.build_user_setting.save
      @token = JsonWebTokenService.encode({ email: @current_user.email })
      AdminNotification.create(
        actor_id: Admin.admin.first.id,
        recipient_id: @current_user.id,
        action: @current_user.support_closer? ? 'New Support Closer Created' : 'New User Created'
      ) if Admin&.admin.present?
    else
      render json: { message: 'OTP not verified' }, status: 401
    end
  end

  def verify_otp
    @user = User.find_by(email: user_params[:email], reset_signup_token: params[:otp]) if user_params[:email].present?
    @user = User.find_by(phone_number: user_params[:phone_number], reset_signup_token: params[:otp]) if user_params[:phone_number].present?
    if @user && @user.signup_token_valid?
      @user.update(is_otp_verified: true)
      @token = JsonWebTokenService.encode({ email: @user.email })
      AdminNotification.create(
        actor_id: Admin.admin.first.id, recipient_id: @user.id, action: 'Please complete your profile'
      ) if Admin&.admin.present?
    else
      render json: { message: 'Incorrect Email or OTP' }, status: 401
    end
  end

  def resend_otp
    twilio_sender_number = Rails.application.credentials.twilio[:sender_number] if Rails.env.development?
    twilio_sender_number = ENV['TWILIO_SENDER_NUMBER'] if Rails.env.production?
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
        render json: { otp: @user.reset_signup_token }, status: :ok
      end
    else
      render json: { message: 'Email/Phone not found' }, status: 401
    end
  end

  def update_social_login
    @current_user.update(user_params.merge(is_confirmed: true, profile_complete: true, is_otp_verified: true))
    @current_user.user_setting.destroy if @current_user.user_setting.present?
    @current_user.build_user_setting.save
    @token = JsonWebTokenService.encode({ email: @current_user.email })
  end

  private

    def user_params
      params.require(:user).permit(:full_name, :email, :password, :phone_number, :description,
        :licensed_realtor, :contacted_by_real_estate, :user_type, :profile_type, :country_code, :country_name,
        :currency_type, :currency_amount, :address, :avatar, :hourly_rate, images: [], certificates: [],
        professions_attributes: [:id, :_destroy, :title], schedule_attributes: [:id, :ending_time, :starting_time, working_days: []],
        mobile_devices_attributes: [:mobile_device_token]
      )
    end
end
