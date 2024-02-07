# frozen_string_literal: true

module StripeService
  require 'stripe'
  extend self

  Stripe.api_key  = ENV['STRIPE_API_KEY']

  def create_customer(name, email)
    handle_request{ Stripe::Customer.create({ name: name, email: email }) }
  end

  def get_customer(customer_id)
    handle_request{ Stripe::Customer.retrieve(customer_id) }
  end

  def create_subscription(customer_id, price_id)
    user = User.find_by(stripe_customer_id: customer_id)
    subscription = Subscription.find_by(user_id: user.id)
    subscription.destroy if subscription
    handle_request{ Stripe::Subscription.create({ customer: customer_id, items: [{price: price_id}] }) }
  end

  def cancel_subscription(subscription_id)
    handle_request{ Stripe::Subscription.cancel(subscription_id) }
  end

  def create_card(customer_id, token)
    handle_request{ Stripe::Customer.create_source(customer_id, { source: token }) }
  end

  def remove_card(customer_id, card_id)
    resp = handle_request{ Stripe::Customer.delete_source(customer_id, card_id) }
    resp&.deleted
  end

  def update_default_card_at_stripe(user, card_id)
    @current_user = User.find_by_id(user)
    handle_request do
      Stripe::Customer.update(
        @current_user.stripe_customer_id,
        {invoice_settings: {default_payment_method: card_id}},
      )
    end
  end

  def create_product(package_name)
    handle_request{ Stripe::Product.create({ name: package_name }) }
  end

  def create_price(price, currency, recurring_interval, product_id)
    handle_request do
      Stripe::Price.create({
        unit_amount: price,
        currency: currency,
        recurring: {interval: recurring_interval},
        product: product_id
      })
    end
  end

  private

    def handle_request
      begin
        yield
      rescue Stripe::InvalidRequestError => e
        puts "Error in stripe API, method: #{caller_locations[1].label}. #{e.message}"
      end
    end

end
