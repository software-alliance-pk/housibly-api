class SupportConversation < ApplicationRecord
  belongs_to :support
  has_many :admin_support_messages, dependent: :destroy
  has_many :user_support_messages, dependent: :destroy
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient, class_name: "Admin", foreign_key: :recipient_id
  enum conv_type: {
    support_closer: 0,
    end_user: 1
  }

end
