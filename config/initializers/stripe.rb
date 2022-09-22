require 'stripe'
Stripe.api_key             = 'sk_test_51Lf25xJxAUizx0q5nlLODfQpgzjCZox9nBzMEGUc3hzSW4ywx7GOU69fuA0FyJ30GSyhIkGFX1RadDP4NuAyqc8B00xyKRAs2h'     # e.g. sk_live_...
StripeEvent.signing_secret = 'whsec_Kb3doZ49Nq5EPcbipWGqmWVkPaApJ1dh' if Rails.env.development?
StripeEvent.signing_secret = 'whsec_qzzu8ubKmmY1Mx3qaQbFdJJ5CeATMO8A' if Rails.env.production?
StripeEvent.configure do |events|
  events.all do |event|
    case event.type
    when 'charge.succeeded'
      StripePaymentJob.perform_now(event)
    when 'customer.subscription.deleted'
      SubscriptionCanceledJob.perform_now(event)
    when 'customer.subscription.created'
      SubscriptionCreatedJob.perform_now(event)
    when 'product.updated'
       ProductUpdatedJob.perform_now(event)
    when 'product.created'
      PackageCreateJob.perform_now(event)
    when 'price.created'
      PackagePriceAddedJob.perform_now(event)
    else
      puts "Unhandled event type: #{event.type}"
    end
  end
end