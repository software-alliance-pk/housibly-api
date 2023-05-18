module SupportsHelper
  def unread_count (support_conversation)
    support_conversation&.support_messages&.where(read_status: false).where.not(sender_id: current_admin.id)&.count
  end
end
