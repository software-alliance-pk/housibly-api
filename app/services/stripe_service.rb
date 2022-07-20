class StripeService
  require 'stripe'
  Stripe.api_key = 'sk_test_51LNZ3BAsady3KIaWsrai2Zq9cT9PCOp5s8AF6JjSyutqxodm7ESoI8EFCKtfC5Cd79CxcklRNVD76aOBwP8XnpO400X2CvQDdP'

  def self.create_customer(name, email)
    Stripe::Customer.create(
      {
        name: name,
        email: email
      })
  end

  def self.create_token(number, exp_month, exp_year, cvc)
    Stripe::Token::create(
      {
        card: {
          number: number,
          exp_month: exp_month,
          exp_year: exp_year,
          cvc: cvc
        }
      })
  end

  def self.create_card(customer_id, token)
    Stripe::Customer.create_source(
      customer_id,
      { source: token },
    )
  end

end