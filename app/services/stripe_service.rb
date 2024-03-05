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

  def set_default_payment_method(customer_id, payment_method_id)
    handle_request{ Stripe::Customer.update(customer_id, invoice_settings: {default_payment_method: payment_method_id}) }
  end

  def attach_payment_method(customer_id, payment_method_id)
    handle_request{ Stripe::PaymentMethod.attach(payment_method_id, {customer: customer_id}) }
  end

  def create_subscription(customer_id, price_id)
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

  def get_transactions(customer_id)
    transactions = handle_request{ Stripe::PaymentIntent.search({query: "status:'succeeded' customer:'#{customer_id}'"}) }
    if transactions
      transactions.map do |tr|
        {
          amount: tr.amount/100.0,
          description: tr.description,
          created_at: Time.at(tr.created).utc.to_datetime,
          currency: tr.currency
        }
      end
    else
      nil
    end
  end

  def get_products
    handle_request{ Stripe::Product.list({active: true, expand: ['data.default_price']}) }
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
