class RemoveMessageFromUnreadTableJob < ApplicationJob
  queue_as :default
  def self.perform_now(*args)
    debugger
    Message.cleanup_read_marks!
  end
end