class JsonWebTokenService
  def self.encode(payload)
    JWT.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
  end
  def self.decode
    JWT.decode( token, Rails.application.secrets.secret_key_base, algorithm: 'HS256' )[0]
  end
end