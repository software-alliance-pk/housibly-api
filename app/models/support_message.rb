class SupportMessage < ApplicationRecord
  has_one_attached :image, dependent: :destroy
  has_one_attached :file, dependent: :destroy
  belongs_to :support_conversation
end
