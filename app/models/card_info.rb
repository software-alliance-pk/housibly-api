class CardInfo < ApplicationRecord
  belongs_to :user

  scope :default_card, -> { where(is_default: true)}

end
