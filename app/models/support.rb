class Support < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum status: [:pending, :in_progress, :closed]
end