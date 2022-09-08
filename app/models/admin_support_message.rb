class AdminSupportMessage < SupportMessage
  belongs_to :support_conversation
  has_one_attached :file
  has_one_attached :image
end