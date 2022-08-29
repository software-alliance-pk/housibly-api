class Message < ApplicationRecord
	belongs_to :conversation
	has_many_attached :images
	belongs_to :user
end
