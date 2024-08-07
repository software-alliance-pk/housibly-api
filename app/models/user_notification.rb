class UserNotification < Notification
	after_create :push_notification
	belongs_to :conversation, optional:true
	belongs_to :property, optional: true

	scope :unread, -> { where(read_at: nil) }

	validates_inclusion_of :event_type, in: ['message', 'support_message', 'buy_property', 'sell_property']

	scope :check_notifiction_send, -> (recipient_id,actor_id){ where(recipient_id: recipient_id, actor_id: actor_id)}

	private

		def push_notification
			case event_type
			when 'support_message'
				NotificationService.fcm_push_notification_for_chat_messages(recipient,actor,self)
			when 'message'
			  NotificationService.fcm_push_notification_for_chat_messages(recipient,actor,self)
			when 'buy_property'
			  NotificationService.fcm_push_notification_for_user_preference_address(recipient,actor,self)
			when 'sell_property'
			  NotificationService.fcm_push_notification_for_user_address_search(recipient,actor,self)
			end
		end
end
