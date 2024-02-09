class UserNotification < Notification
	after_create :push_notification
	belongs_to :conversation, optional:true

	validates_inclusion_of :event_type, in: ['message', 'property_match', 'address_search']

	scope :check_notifiction_send, -> (recipient_id,actor_id){ where(recipient_id: recipient_id, actor_id: actor_id)}

	private

		def push_notification
			case event_type
			when 'message'
			  NotificationService.fcm_push_notification_for_chat_messages(recipient,actor,self)
			when 'property_match'
			  NotificationService.fcm_push_notification_for_user_preference_address(recipient,actor,self)
			when 'address_search'
			  NotificationService.fcm_push_notification_for_user_address_search(recipient,actor,self)
			end
		end
end
