class SocialLoginService
  require 'net/http'
  require 'uri'

  def initialize(mobile_device_token)
    @mobile_device_token = mobile_device_token
  end

  def google_signup(token)
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}")
    response = Net::HTTP.get_response(uri)
    unless response.code == '200'
      puts JSON.parse(response.body)
      return {error_message: 'Error in Google auth or token expired'}
    end

    json_response = JSON.parse(response.body)
    return {error_message: 'Unable to fetch email for the provided Google account'} if json_response['email'].blank?

    user = create_or_find_user(json_response['email'], json_response['name'], google_user_id: json_response['sub'])
    return { error_message: 'Unable to create user account' } if user.blank?
    return { error_message: 'Unable to fetch name for the provided Google account' } if user[:error_message] == 'missing name'

    { user: user, token: JsonWebTokenService.encode({ email: user.email }) }
  end

  def apple_signup(apple_user_id, email, name)
    user = User.find_by(apple_user_id: apple_user_id)
    unless user
      if email.blank?
        return { error_message: 'Unable to fetch email for the provided Apple account' }
      else
        user = create_or_find_user(email, name, apple_user_id: apple_user_id)
        return { error_message: 'Unable to create user account' } if user.blank?
        return { error_message: 'Unable to fetch name for the provided Apple account' } if user[:error_message] == 'missing name'
      end
    end

    { user: user, token: JsonWebTokenService.encode({ email: user.email }) }
  end

  private

    def create_or_find_user(email, name, apple_user_id: nil, google_user_id: nil)
      user = User.find_by(email: email)
      if user
        attributes = { login_type: 'social_login', is_otp_verified: true }
        attributes[:apple_user_id] = apple_user_id if apple_user_id.present?
        attributes[:google_user_id] = google_user_id if google_user_id.present?
        user.assign_attributes(attributes)
        user.save(validate: false) && user
      else
        return { error_message: 'missing name' } if name.blank?
        password_digest = SecureRandom.hex(10)
        user = User.new(
          email: email,
          full_name: name,
          password: password_digest,
          password_confirmation: password_digest,
          login_type: "social_login",
          profile_complete: false,
          is_otp_verified: true
        )
        user.apple_user_id = apple_user_id if apple_user_id.present?
        user.google_user_id = google_user_id if google_user_id.present?
        user.mobile_devices.build(mobile_device_token: @mobile_device_token)
        user.save(validate: false) && user
      end
    end

end
