class Conversation < ApplicationRecord
	belongs_to :sender, class_name: "User", foreign_key: :sender_id
	belongs_to :recipient, class_name: "User", foreign_key: :recipient_id
	has_many :messages, dependent: :destroy
	has_many :user_notification
	acts_as_paranoid
end
