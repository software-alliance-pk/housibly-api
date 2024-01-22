class Message < ApplicationRecord
	after_create :update_conversation_message_counter
	belongs_to :conversation
	has_one_attached :image
	belongs_to :user

	def update_conversation_message_counter
    prev_value = (self.conversation.unread_message) + 1
    self.conversation.update_attribute(:unread_message,prev_value)
	end
	
	def as_json(options = {})
    super(options).merge(
      "image" => image_url
    )
  end

  private

  def image_url
    image.url if image.attached?
  end
end
