require 'stripe'
Stripe.api_key             = 'sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h'     # e.g. sk_live_...
StripeEvent.signing_secret = 'whsec_6ov5vWfQNVQc2LN4WvRxUafBFbxY5oat'
StripeEvent.configure do |events|
  events.all do |event|
    case event.type
    when 'charge.succeeded'
      StripePaymentJob.perform_now(event)
    when 'customer.subscription.deleted'
      SubscriptionCanceledJob.perform_now(event)
    else
      puts "Unhandled event type: #{event.type}"
    end
  end
end