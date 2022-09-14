class UserNotification < Notification
	after_create :push_notification
	 belongs_to :conversation 
	def push_notification
    NotificationService.fcm_push_notification_for_chat_messages(recipient,actor,self.type,self,self.action,self.title)
	end

	scope :check_notifiction_send, -> (recipient_id,actor_id){ where(recipient_id: recipient_id, actor_id: actor_id)}

end