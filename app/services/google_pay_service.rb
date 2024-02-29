class GooglePayService
  require 'stripe'
  Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.development?
  Stripe.api_key = ENV['STRIPE_API_KEY'] if Rails.env.production?


  def self.google_pay
    google = Stripe::PaymentIntent.create(
      payment_method_types: ['card'],
      amount: (1000).to_i,
      currency: 'usd',
      )
  end
end
