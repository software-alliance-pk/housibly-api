class ApplePayService
  require 'stripe'
  Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.development?
  Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.production?

  def self.apple_pay
    intent = Stripe::PaymentIntent.create({
              amount: (1200 * 100).to_i,
              currency: 'usd',
            })
  end
end