class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action :authenticate_user, only: [:create, :verify_otp, :resend_otp]
  include CreateOtp

  def create
    get_location = UserCurrentLocationService.new.call(request.safe_location)
    puts get_location
    @user = User.new(user_params)
    @user.address = get_location[:full_address]
    if @user.save
      signup_otp(@user)
    else
      render_error_messages(@user)
    end
  end

  def update_personal_info
     if @current_user.is_otp_verified
      if @current_user.want_support_closer?
        @current_user.build_schedule(schedule_params) unless @current_user.schedule
        @current_user.professions.destroy_all if @current_user.professions.present? 
        user_profession[:titles].each do |user|  
          @current_user.professions.build(title:user)
        end
        @current_user.schedule.update(schedule_params) if @current_user.schedule
      end
      @current_user.update(user_params.merge(is_confirmed: true,login_type: "manual", profile_complete: true))
      @current_user.user_setting.destroy if @current_user.user_setting.present?
      @current_user.build_user_setting.save
      @token = JsonWebTokenService.encode({ email: @current_user.email })
    else
      render json: { message: "OTP not verified" }, status: 401
    end
  end

  def update_social_login
    @current_user.build_schedule(schedule_params) unless @current_user.schedule
    @current_user.professions.destroy_all if @current_user.professions.present? 
    if user_profession[:titles].present?
      user_profession[:titles].each do |user|  
        @current_user.professions.build(title:user)
      end
    end
    @current_user.schedule.update(schedule_params) if @current_user.schedule
    @current_user.update(user_params.merge(is_confirmed: true,profile_complete: true,is_otp_verified: true))
    @current_user.user_setting.destroy if @current_user.user_setting.present?
    @current_user.build_user_setting.save
    @token = JsonWebTokenService.encode({ email: @current_user.email })
  end

  def verify_otp
    @user = User.find_by(email: user_params[:email],
                         reset_signup_token: params[:otp]) if user_params[:email].present?
    @user = User.find_by(phone_number: user_params[:phone_number],
                         reset_signup_token: params[:otp]) if user_params[:phone_number].present?
    if @user && @user.signup_token_valid?
      @user.update(is_otp_verified: true)
      @token = JsonWebTokenService.encode({ email: @user.email })
      AdminNotification.create(actor_id: Admin.admin.first.id,
                               recipient_id: @user.id, action: "Please complete your profile") if Admin&.admin.present?
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
  def social_login_params
    params.require(:user).
      permit(:full_name, :email, :phone_number, :description,
       :licensed_realtor,:contacted_by_real_estate, :user_type, :profile_type,
        :otp, :country_code, :currency_type, :currency_amount, :country_name, :address, :avatar, images: [], certificates: [])
  end

  def user_params
    params.require(:user).
      permit(:full_name, :email, :password, :phone_number, :description,
       :licensed_realtor,:contacted_by_real_estate, :user_type, :profile_type,
        :otp, :country_code, :currency_type, :currency_amount, :country_name, :address, :avatar, images: [], certificates: [])
  end
  def user_profession
     params.require(:user).permit(titles: [])
  end

  def schedule_params
     params.require(:user).permit(:ending_time,:starting_time,working_days: [])
  end
end
