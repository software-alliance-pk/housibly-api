class AdminNotification < Notification
  belongs_to :actor, class_name: 'Admin', foreign_key: :actor_id
  belongs_to :recipient, class_name: 'User',foreign_key: :recipient_id
  after_create :push_notification
	def push_notification
    NotificationService.fcm_push_notification_for_complete_profile(recipient,actor,self.type,self,self.action) 
  end
end