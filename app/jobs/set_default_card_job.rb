class SetDefaultCardJob < ApplicationJob
  queue_as :default

  def perform(stripe_customer_id, card_id)
    StripeService.set_default_payment_method(stripe_customer_id, card_id)
  end
end
