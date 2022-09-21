class StripePaymentJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    debugger
    payload = args.last.data.to_h
    parse_data = parse_data(payload)
    debugger
  end

  def parse_data(payload)
    data = payload.fetch(:object)
    amount = data["amount"]
    amount_capture = data["amount_captured"]
  end
end