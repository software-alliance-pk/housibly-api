class RemoveMessageFromUnreadTableJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    Message.cleanup_read_marks!
  end
end