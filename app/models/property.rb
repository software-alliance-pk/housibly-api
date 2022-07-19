class Property < ApplicationRecord
  has_many_attached :images
  # has_many :rooms, dependent: :destroy
  belongs_to :user
end
