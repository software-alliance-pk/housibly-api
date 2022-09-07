class SupportMessage < ApplicationRecord
  belongs_to :support_conversation
  belongs_to :user, class_name: "User",foreign_key: :user_id
  belongs_to :admin, class_name: "Admin", foreign_key: :user_id
  has_one_attached :image

end
