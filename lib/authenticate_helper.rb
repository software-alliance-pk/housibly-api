module AuthenticateHelper
  def authenticate_user
    # email = JsonWebTokenService.decode(request.headers["HTTP_AUTH_TOKEN"])["email"] rescue nil
    # phone = JsonWebTokenService.decode(request.headers["HTTP_AUTH_TOKEN"])["phone_number"] rescue nil
    # @current_user = User.find_by(email: email) if email.present?
    # @current_user = User.find_by(phone_number: phone) if phone.present?
    # render json: { message: "not authorized" }, status: 401 unless @current_user
    begin
      decoded_token = JsonWebTokenService.decode(request.headers["HTTP_AUTH_TOKEN"])
    rescue JWT::DecodeError => e
      render json: { message: "JWT decode error: #{e.message}" }, status: :unauthorized
      return
    rescue JWT::VerificationError => e
      render json: { message: "JWT verification error: #{e.message}" }, status: :unauthorized
      return
    rescue StandardError => e
      render json: { message: "Unexpected error: #{e.message}" }, status: :unauthorized
      return
    end
    
    email = decoded_token["email"]
    phone = decoded_token["phone_number"]
    
    if email.present?
      @current_user = User.find_by(email: email)
    elsif phone.present?
      @current_user = User.find_by(phone_number: phone)
    end
    
    if @current_user.nil?
      render json: { message: "User not found for the provided credentials" }, status: :unauthorized
    end
    # header = request.headers['Authorization']
    # header = header.split(' ').last if header
    # begin
    #   @decoded = JsonWebTokenService.decode(header)
    #   @current_user = User.find_by_id(@decoded[:user_id]) || User.find_by_email(@decoded[:email])
    # rescue ActiveRecord::RecordNotFound => e
    #   render json: { message: e.message }, status: :unauthorized
    # rescue JWT::DecodeError => e
    #   render json: { message: e.message }, status: :unauthorized
    # end
  end

  def user_sign_in?
    !!current_user
  end

  def current_user
    @current_user
  end
end