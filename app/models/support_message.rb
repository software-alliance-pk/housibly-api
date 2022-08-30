class SupportMessage < ApplicationRecord
  belongs_to :support_conversation
  belongs_to :user
  has_one_attached :image

end
