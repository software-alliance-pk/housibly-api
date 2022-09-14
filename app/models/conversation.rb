class Conversation < ApplicationRecord
	belongs_to :sender, class_name: "User", foreign_key: :sender_id
	belongs_to :recipient, class_name: "User", foreign_key: :recipient_id
	has_many :messages, dependent: :destroy
	has_many :user_notification
	acts_as_paranoid

	scope :find_specific_conversation, -> (id){ where("recipient_id = (?) OR  sender_id = (?)", id, id) }

	def self.get_chat_between_user(user_1, user_2)
		Conversation.find_by(sender: user_1,recipient:user_2) ||
			Conversation.find_by(sender: user_2,recipient:user_1)
	end

	def self.get_all_conversation_of_specific_user(id)
		Conversation.where(sender_id: id).or(Conversation.where(recipient_id:id))
	end
end
