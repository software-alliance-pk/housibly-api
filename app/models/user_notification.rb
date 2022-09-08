class UserNotification < Notification
	after_create :push_notification
	after_find :push_notification
	def push_notification
    NotificationService.fcm_push_notification_for_chat_messages(recipient,actor,self.type,self,self.action) 
  end
end