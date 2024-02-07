class AdminNotification < Notification
  belongs_to :actor, class_name: 'Admin', foreign_key: :actor_id
  belongs_to :recipient, class_name: 'User',foreign_key: :recipient_id
  after_create :push_notification

	def push_notification
    NotificationService.fcm_push_notification_for_complete_profile(recipient,actor,self)
  end

scope :user_create, -> { where('(action = (?) or action = (?)) and read_at  IS NULL','New User Created','New Support Closer Created') }
scope :active_deactive, -> { where("(action ILIKE ? OR action  ILIKE ?) and read_at  IS NULL", "% active%", "%deactive%")}
scope :ticket, -> { where("action ILIKE ? and read_at  IS NULL", "% generated %")}
scope :reporting, -> { where("action ILIKE ? and read_at  IS NULL", "% reported %")}
scope :admin_create, -> { where('action = (?)  and read_at  IS NULL','New Admin Created') }
scope :sub_admin_active_deactive, -> { where("(action ILIKE ? OR action  ILIKE ?) and read_at  IS NULL", "%Sub Admin is  active%", "Sub Admin is %deactive%")}


scope :notification_count, -> { where(read_at: nil).count}
end
