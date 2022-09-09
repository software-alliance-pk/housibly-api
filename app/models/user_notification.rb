class UserNotification < Notification
	after_create :push_notification
	 belongs_to :conversation 
	def push_notification
    NotificationService.fcm_push_notification_for_chat_messages(recipient,actor,self.type,self,self.action,self.title)
  end
end