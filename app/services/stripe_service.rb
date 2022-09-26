class StripeService
  require 'stripe'
  # Stripe.api_key = Rails.application.credentials.stripe[:api_key] if Rails.env.development?
  Stripe.api_key ="sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h"
  Stripe.api_key = 'sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h' if Rails.env.production?

  def self.create_customer(name, email)
    response = Stripe::Customer.create(
      {
        name: name,
        email: email
      })
    return response
  end

  def self.update_default_card_at_stripe(user,card_id)
    @current_user = User.find_by_id(user)
    Stripe::Customer.update(
      @current_user.stripe_customer_id,
      {invoice_settings: {default_payment_method: card_id}},
      )
  end

  def self.create_subscription(customer_id,price_id)
    user = User.find_by(stripe_customer_id: customer_id)
   subscription = Subscription.find_by(user_id:user.id)
    if subscription
      subscription.destroy
      subscription = Stripe::Subscription.create({customer: customer_id,items: [{price: price_id},],})
    else
      subscription = Stripe::Subscription.create({customer: customer_id,items: [{price: price_id},],})
    end
  end

  def self.create_product(package_name)
   product=  Stripe::Product.create(
      {
        name: package_name,
      }
      )

  end

  def self.create_card(customer_id,token)
    card = Stripe::Customer.create_source(customer_id, { source: token })
    return card
  end

end
