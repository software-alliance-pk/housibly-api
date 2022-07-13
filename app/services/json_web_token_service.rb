class JsonWebTokenService
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode payload, shift_credentials, 'HS256'
  end

  def self.decode(token)
    JWT.decode(token, shift_credentials, algorithm: 'HS256')[0]
  end

  def self.shift_credentials
    if Rails.env.production?
      Rails.application.secret_key_base
    else
      Rails.application.secrets.secret_key_base
    end
  end

end