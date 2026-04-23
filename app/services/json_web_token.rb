module JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base
  TOKEN_EXPIRY = 24.hours

  def self.encode(payload, exp = TOKEN_EXPIRY.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithms: ["HS256"])[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
