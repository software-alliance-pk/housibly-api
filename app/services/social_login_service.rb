class SocialLoginService
  PASSWORD_DIGEST = SecureRandom.hex(10)
  APPLE_PEM_URL = 'https://appleid.apple.com/auth/keys'
  require 'net/http'
  require 'uri'

  def initialize(provider, token)
    @token = token
    @provider = provider.downcase
  end

  def social_login
    if @provider == 'google'
      google_signup(@token)
    elsif @provider == 'apple'
      apple_signup(@token)
    end
  end

  def google_signup(token)
    require 'net/http'
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}")
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body) if response.code != '200'
    json_response = JSON.parse(response.body)
    user = create_user(json_response['email'], json_response['sub'], json_response)
    token = JsonWebTokenService.encode({ email: user.email })
    [user, token, json_response['picture']]
  end

  def apple_signup(token)
    jwt = token
    begin
      header_segment = JSON.parse(Base64.decode64(jwt.split(".").first))
      alg = header_segment["alg"]
      kid = header_segment["kid"]
      apple_response = Net::HTTP.get(URI.parse(APPLE_PEM_URL))
      apple_certificate = JSON.parse(apple_response)
      keyHash = ActiveSupport::HashWithIndifferentAccess.new(apple_certificate["keys"].select { |key| key["kid"] == kid }[0])
      jwk = JWT::JWK.import(keyHash)
      token_data = JWT.decode(jwt, jwk.public_key, true, { algorithm: alg })[0]
    rescue StandardError => e
      return e.as_json
    end
    data = token_data.with_indifferent_access
    user = create_user(data['email'], data['sub'], data)
    token = JsonWebTokenService.encode({ email: user.email })
    [user, token," "]

  end

  private

  def create_user(email, provider_id, response)
    resource = User.find_by(email: email)
    if resource
      resource
    else
      name =  response['name'].present? ?  response['name'] : "apple don't provide name"
      User.create!(email: response['email'], full_name: name, password: PASSWORD_DIGEST, password_confirmation: PASSWORD_DIGEST)
    end
  end

end