class SubscriptionCanceledJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    debugger
  end

  def parse_data(payload)

  end
end