class StripeService
  require 'stripe'
  # Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.development?
    Stripe.api_key ="sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h"

  Stripe.api_key = 'sk_test_51LNZ3BAsady3KIaWsrai2Zq9cT9PCOp5s8AF6JjSyutqxodm7ESoI8EFCKtfC5Cd79CxcklRNVD76aOBwP8XnpO400X2CvQDdP' if Rails.env.production?

  def self.create_customer(name, email)
    Stripe::Customer.create(
      {
        name: name,
        email: email
      })
  end

  def self.create_subscription(customer_id,price_id)
    debugger
    Stripe::Subscription.create({
  customer: customer_id,
  items: [
    {price: price_id},
  ],
})
  end

  def self.create_product
   product=  Stripe::Product.create(
      {
        name: '1 YEAR'
      }
      )
   Stripe::Price.create({
  unit_amount: 8000,
  currency: 'usd',
  recurring: {interval: 'month'},
  product: product.id,
})


  end
  

  def self.create_card(customer_id, token)
    Stripe::Customer.create_source(
      customer_id,
      { source: token },
    )
  end

  def self.charge(amount, currency, card_id)
    Stripe::Charge.create(
      {
        amount: amount,
        currency: currency,
        source: card_id
      })
  end

end
