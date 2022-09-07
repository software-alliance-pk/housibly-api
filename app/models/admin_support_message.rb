class AdminSupportMessage < SupportMessage
  belongs_to :support_conversation,class_name: "Admin", foreign_key: :sender_id
  has_one_attached :image
end