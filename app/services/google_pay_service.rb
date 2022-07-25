class GooglePayService
  require 'stripe'
  Stripe.api_key = Rails.application.credentials.stripe[:api_key]


  def self.google_pay
    google = Stripe::PaymentIntent.create(
      payment_method_types: ['card'],
      amount: (1000).to_i,
      currency: 'usd',
      )
  end
end