class StripePaymentJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    payload = args.last.data.to_h
    data = payload.fetch(:object)
    #Subscription.create(price: data.amount, user_id:@current_user.id,status:)
    #parse_data = parse_data(payload)
  end

  def parse_data(payload)
    data = payload.fetch(:object)
    amount = data["amount"]
    amount_capture = data["amount_captured"]
  end
end