class UserNotification < Notification
	after_create :push_notification
	def push_notification
    # user = self.user if notification_for.in?(["draft","is_quickys","New_Message","Comment"])
    NotificationService.fcm_push_notification_for_chat_messages(recipient,actor,self.type,self,self.action) 
    # PushNotificationService.fcm_push_notification(user,self.title,self.body,"",self.priority,self.notification_type,self.post_id) if self.notification_for.in?(["Comment","draft","is_quickys"])
    # PushNotificationService.fcm_push_notification_for_all_user(self.title,self.body,"",self.priority,self.notification_type) if self.notification_for.in?(["posted"])
  end
end