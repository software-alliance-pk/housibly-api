class SetDefaultCardJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    user_id = args[0]
    card_id = args[1]
    StripeService.update_default_card_at_stripe(user_id,card_id)
  end
end