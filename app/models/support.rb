class Support < ApplicationRecord
  has_one_attached :image
  has_one :support_conversation, dependent: :destroy

  enum status: [:pending, :in_progress, :closed]
end