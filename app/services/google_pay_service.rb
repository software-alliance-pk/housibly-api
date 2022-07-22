class GooglePayService
  require 'stripe'
  Stripe.api_key = 'sk_test_51LNZ3BAsady3KIaWsrai2Zq9cT9PCOp5s8AF6JjSyutqxodm7ESoI8EFCKtfC5Cd79CxcklRNVD76aOBwP8XnpO400X2CvQDdP'


  def self.google_pay
    google = Stripe::PaymentIntent.create(
      payment_method_types: ['card'],
      amount: (1000).to_i,
      currency: 'usd',
      )
  end
end