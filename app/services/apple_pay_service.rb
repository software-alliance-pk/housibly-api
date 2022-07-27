class ApplePayService
  require 'stripe'
  Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.development?
  Stripe.api_key = 'sk_test_51LNZ3BAsady3KIaWsrai2Zq9cT9PCOp5s8AF6JjSyutqxodm7ESoI8EFCKtfC5Cd79CxcklRNVD76aOBwP8XnpO400X2CvQDdP' if Rails.env.production?

  def self.apple_pay
    intent = Stripe::PaymentIntent.create({
              amount: (1200 * 100).to_i,
              currency: 'usd',
            })
  end
end