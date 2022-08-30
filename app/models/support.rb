class Support < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_one :support_conversation

  enum status: [:pending, :in_progress, :closed]
end