class SubscriptionUpdatedJob < ApplicationJob
  queue_as :default

  def perform(stripe_subscription)
    subscription = Subscription.find_by(subscription_id: stripe_subscription.id)
    subscription.update(status: stripe_subscription.status) if subscription
  end
end
