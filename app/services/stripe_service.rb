class StripeService
  require 'stripe'
  Stripe.api_key = Rails.application.credentials.stripe[:api_key]

  def self.create_customer(name, email)
    Stripe::Customer.create(
      {
        name: name,
        email: email
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
