require 'stripe'
Stripe.api_key = ENV["STRIPE_API_KEY"]
StripeEvent.signing_secret = ENV['SIGNING_SECRET']
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
    when 'price.updated'
      PackagePriceUpdatedJob.perform_now(event)
    else
      puts "Unhandled event type: #{event.type}"
    end
  end
end